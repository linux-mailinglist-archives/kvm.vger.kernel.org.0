Return-Path: <kvm+bounces-56194-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 86962B3AD3E
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 00:05:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A02B71C856DC
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 22:05:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A55412C11E9;
	Thu, 28 Aug 2025 22:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="i8dGrOsg"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1910D225D6;
	Thu, 28 Aug 2025 22:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756418728; cv=fail; b=l1PHoqOursE/JSGwAgoYfBoLRqqJlb9Pw/Uwd5NGGPg+5aqgsPZerUndB+QTnZxFl2W3qUlzFIJY1x/W/z3tbgthE4XfyVPbMnK52EO60NyhdEn2eBXkUNB7poqmgWaJll/zDBYx+arkUG2PJvQ6/DJ5XXO+Nkx6C8+vh3wvAOE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756418728; c=relaxed/simple;
	bh=tSMLxPxsbYDtbY4B4fI4vbS4iGOET/z4NReweBauEK0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=FKQv2gsr3eg6WBe1kL+8Zuus6u13qEK8h5ZCBEtvi6zbzuU9YcR8oozoB3Frs8YkVPuGjlaM2ulGUZtRptxgqxOYCVHrtGpovl3Ah+IOy66MHSEDhvDuxoE26QBNXwzs+k9cURFHEweQdO3HChrwTG+TOUnq2QLSWWat2pL2T7Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=i8dGrOsg; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756418727; x=1787954727;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=tSMLxPxsbYDtbY4B4fI4vbS4iGOET/z4NReweBauEK0=;
  b=i8dGrOsge/7c4dsnXL0ukcuIUdySPgfiKjC0oKU5oGuvSP224Lmh7iuX
   UXSiia9XIKDgzNlsIymIeq0pFwDUZiXNaUPEJosT28yNlsVnY1SMS/Fsb
   ZqfU/eAIfaX1KorKfS3snrR4+YTKhu5/ZQL1/n5yfMirGctwEg5pgpGpd
   VWeWPW0mpoKxNPIc8uM0i+wbgekbsra/Y45qa34mAPo3DwWSXagmpfOl6
   0FsVLiMPVOTbP7NU+DiaDuFUi7Nm4PBxQNylY19pIzDIXGL0B5AY165zW
   uIAexNp3C4F9S3VwXhTM24aa4V8ipVZMzU+zjKYrYx7NsZMZiZCAljUqr
   A==;
X-CSE-ConnectionGUID: LHhfDFOhTAejH6UcUTDFtw==
X-CSE-MsgGUID: decZr08FRraSzW9lAgz/Vw==
X-IronPort-AV: E=McAfee;i="6800,10657,11536"; a="69296540"
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="69296540"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 15:05:23 -0700
X-CSE-ConnectionGUID: v83bulvKTNm9NDDWfCn8/A==
X-CSE-MsgGUID: YFdmBdDkQG6bohZqt+3G4w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="175504518"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 15:05:19 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 28 Aug 2025 15:05:16 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 28 Aug 2025 15:05:16 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (40.107.95.88) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 28 Aug 2025 15:05:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QcHsnKBpm/m68kcIU+RofU8SuVOCt2cEka06PkVMZzDzzYBlUiJFK8KRtlVrrLdlmjix3bKEOPokcKZYXsI5XB+GXPhCpf2qLAnp1iv4+ecF60cR+bRzUAsxifECFkxSytH0hP7FIuxrfVIpWQgd143DmxWYMcfYM1u9xLMQT9w2FBdmIhJN1+H/dqZIVNv04ZwyknRQ+Cp2QG6IREszcPwdicEWxzvCyDjhHDQD23X2YO92AGDk+5SrBmI88ci5ey8yGTUB2y0l/TYz4It1o3VMmOZD4jNF76JpjF75EuRpDAx8YlexnYmnKZIqwYVZGDfbl3+7uoA6izRTQn8xlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JugQXtUa8on4kpxLDGaW6sUPEoAZTlTSDNsIT5q55H8=;
 b=j0klLhAjv5nYLAl+MKkBpHNOuD4Ou6Exv+UpSB3SrPFG1jCUJkjRfDTvGtGBIx/PwhCp2cQtAR5C/M/DQ8WN46rI1qr09imS0ERfq50LSMu4w+/+jbxs4aYj9JJ0Czh0PPFsehyFEfBpCOb25RjoxyEQEBtTBa4ulRA++KDTnoEIZ9f9LO1xeTXt1ls08a9F5FN/qw2BV4Abhx7My+bEMFv2Y0Hwp97+EJr0TIMk9VZEJTTWKPIBQMkyidhu1+EEeq+XLr0Sf7TSoVevAsz/4WKGxXTGWTJoV6NvKN2H58QSSWWGRZNsP9rcTfxgg44KP6d3uWgoH5SnDcHWA4ikEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c) by BY1PR11MB8030.namprd11.prod.outlook.com
 (2603:10b6:a03:522::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Thu, 28 Aug
 2025 22:05:03 +0000
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::bbd5:541c:86ba:3efa]) by PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::bbd5:541c:86ba:3efa%7]) with mapi id 15.20.9052.019; Thu, 28 Aug 2025
 22:05:03 +0000
Date: Thu, 28 Aug 2025 17:06:51 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "michael.roth@amd.com" <michael.roth@amd.com>,
	"Weiny, Ira" <ira.weiny@intel.com>
Subject: Re: [RFC PATCH 09/12] KVM: TDX: Fold
 tdx_mem_page_record_premap_cnt() into its sole caller
Message-ID: <68b0d2fb207cc_27c6d294e1@iweiny-mobl.notmuch>
References: <20250827000522.4022426-1-seanjc@google.com>
 <20250827000522.4022426-10-seanjc@google.com>
 <aK7Ji3kAoDaEYn3h@yzhao56-desk.sh.intel.com>
 <aK9Xqy0W1ghonWUL@google.com>
 <aK/sdr2OQqYv9DBZ@yzhao56-desk.sh.intel.com>
 <aLCJ0UfuuvedxCcU@google.com>
 <fcfafa17b29cd24018c3f18f075a9f83b7f2f6e6.camel@intel.com>
 <aLC7k65GpIL-2Hk5@google.com>
 <8670cd6065b428c891a7d008500934a57f09b99f.camel@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8670cd6065b428c891a7d008500934a57f09b99f.camel@intel.com>
X-ClientProxiedBy: MW4P223CA0023.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:303:80::28) To PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPF9E162731D:EE_|BY1PR11MB8030:EE_
X-MS-Office365-Filtering-Correlation-Id: b95b4452-5da2-47b9-cc5e-08dde67ef0a2
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?Tbwv30zHHglH3n4uJ1XsROV0t+3I9f5bqzE793Za4LWLunOmWpV5ER8Nyl?=
 =?iso-8859-1?Q?8whlse1xPB1PJU+8fDlxKZjqs8fzvssMTPSVYhvBbXdXvQTLOHRJVMV/AY?=
 =?iso-8859-1?Q?aJjrlIoyGfj8cvCCCaQS/iV4EjY+waXbdnMmIoJsurTmijGqARfDmBZr/Q?=
 =?iso-8859-1?Q?F2MwaELTf5LaRFlnBto7MG6E/AW10znRVbRbVSCoJpmlJbnOeLuofAguk4?=
 =?iso-8859-1?Q?fHNYC39kE6HzjyXoRodGq57f5zsVNggQ+IJUGMuar00UwEfp3EZcFJ32J0?=
 =?iso-8859-1?Q?zQDxKpleBTxlRRScbRrwyj/uhTnYuiRdosCcuIgNzGSMOZ5r7kPkqqzkAh?=
 =?iso-8859-1?Q?skbdG+yyzLjj/eqv+u5XU5L/CYCg9fjuOD0Sn/ED0oIqrJ22UCqB+eE97G?=
 =?iso-8859-1?Q?m8d+6CipS/6Dxuk1zSzrF0iD+RnyhcNK0IjwUenCNaCHsbLytws+l70MHS?=
 =?iso-8859-1?Q?P2bfJyZ7en/3Ss1zhdRt5oyZIvu2//NuV9v6NcxLILA2hsJwr1YbLKOS9v?=
 =?iso-8859-1?Q?l8S54FpZ6n898VBHWsUg8g2qKoUtAWBi+dPjju6BRJuvtBEmhG59joZet2?=
 =?iso-8859-1?Q?EpRaCc+B32wSuLMCDsnC2WwUI5GpUBeSqigYDq+2j+yf0p/6qEu2uExp8Q?=
 =?iso-8859-1?Q?Zft7JhZXeXCJvmyb9+PfyHFJ9pLPu+Njxl6AzllahbGBcSlSlL35mX6pSM?=
 =?iso-8859-1?Q?a/v3gFiX1fKdlCO8GKWxz5TZbQC97OEDTZZw9v/dy93LNCMw4bgaBrhwA2?=
 =?iso-8859-1?Q?fp4iQnRywbimTklShzTEgSsq0+YjfpV41vkCvNoKPaw+5z0AJtghxixNjx?=
 =?iso-8859-1?Q?584UNViKUo1vG2tdW7xGbTMVJWpOapJ2b/uOsiq7cMZuWwacwBwDoGm8L1?=
 =?iso-8859-1?Q?k30NkJkSn81Y0xGr2kMDFi3XKi0fBkWAWTap4c0ixajTSJdFoVN4cxMTz+?=
 =?iso-8859-1?Q?jiAdWuzpnng5tiWL85FzymizX1/3QJU1lVELJgc7ciP2Ck7cIEynp6774k?=
 =?iso-8859-1?Q?WL+KFfcYsm3L0Ts19UJA8cJh1d5qzGe4lFGkj+S4DGFtHTaO88SlWVCXwb?=
 =?iso-8859-1?Q?CPIgSWlgifI0K54qEXx05MT3V3pO15cF81PENF0T/6uaoy+WJm+80CEOXX?=
 =?iso-8859-1?Q?0Sp4tF+PC8yU61fkQgyvJPd2B5W3qaylbpE0PVZRD5wkcAOvS42kUV+X7d?=
 =?iso-8859-1?Q?y6ciwMvpTYN/v5gVLHEB4bsz16zw/nucYxP0I11TbSDEFJkl6PrY2Ysjic?=
 =?iso-8859-1?Q?Xmva3ajwqO7Xz3FpT7cht4RaaPAF60hRQa29HMxNHPmpY56+PJr1GC3qi9?=
 =?iso-8859-1?Q?UjXZY9EJRhINjpbhWFJ9iXDCHT6hMcr8+wDUnaNV+eMR9izSBEmXILI1U1?=
 =?iso-8859-1?Q?4uU4mbEdiwBRJekAeYAFycmcvac9QxijZClCpsTXEZBUGWuuMqPQkQ0kJa?=
 =?iso-8859-1?Q?087yv3g1M6l/pLN1IyvK9dP28mZ49yXMwpTSBJoeETwCe1QM3J1OKLjWn1?=
 =?iso-8859-1?Q?0=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPF9E162731D.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?McDParnqHkVeuJZbc+H96PvcasCvHi6t7hzLuapyzzF9MI/HKDMfA/NZ/9?=
 =?iso-8859-1?Q?KZWhG/zU4zJDiP/gQpRPWMvRf5wcXE7tMyte3hUBhz96tNlhApBYAKIhOz?=
 =?iso-8859-1?Q?EObNDQeC0BhUnXGs/bj8lBuTAZdDfW7yuuyOyDnEPX8XxxqpUlSjnAkqvB?=
 =?iso-8859-1?Q?zJlw0YIrtuuExeX4/o3uTqk0Dra83HvhfELY5D4SnYeae01EBLtF78haZz?=
 =?iso-8859-1?Q?QG7kKzVONFtfznRNt7pgJtazOLiopTG/TIj/yp8oxn4zGU12Ull693Ybw6?=
 =?iso-8859-1?Q?rMGf0dsMTd2SbIorPi4XS2p74qjeFKw7IWaeMbYKHyjgJGlRlQmqy6ByIr?=
 =?iso-8859-1?Q?gkzFSd91kFleLjWxUoXSyfZ3jNgs2Rg+0rzTVQ2q/WO2X+DFoLT9H+/6tR?=
 =?iso-8859-1?Q?QAYWEQkgcIvKHQmSfUPCOX5MvjhuZGikpnjJ7tFgFnrFyKa12YSO32ImX/?=
 =?iso-8859-1?Q?zrTyz+efFAO9jXgy1T4vmyOgv1kfiUqPyjwJPXWQtX9bPNfdL7m7kSi6oS?=
 =?iso-8859-1?Q?/AfxLp5o+UwTzcAss5HZMjGr+Ba5KklHz3B2uJY1TPxIn0chh2PytgAfrx?=
 =?iso-8859-1?Q?XM/KNydfPYSQtl1qvOXiOHhPcZ+9NX2VtQtT8/nzUF0VfPO+t8LPvIlQ1L?=
 =?iso-8859-1?Q?UieAHnclDaRcbaNEBxhjaYCnoJsqEBlr2+rMXkSSLBILWnwcj2leOP0SIk?=
 =?iso-8859-1?Q?NMN9gm2bh2Suf5f1e4AxIf7jMz3IuQSiUl5PTWEwxBRlDRN4I9Gd1BFd4V?=
 =?iso-8859-1?Q?+ih6lvq2kWorykSr22zDEIAE+gA6qn0LB5BcsNDRv5lcYYc86+NIjKcmOA?=
 =?iso-8859-1?Q?sRRj0imUPKUSoMW9uxlFQ1auvIG4F5jMOwCIqAl1c2VBQEUHE+c82PPRwJ?=
 =?iso-8859-1?Q?eLx/WLtid0Q+8JfaHdWMAfjwk71WYuqwgGh8LuoSBsKZrmQzmtOosa3ea0?=
 =?iso-8859-1?Q?q9kLeT2QMp3UYfKCTscx3dTdQmx2fh1YBVPwuEi0E86WTJ77edWkHg7xkl?=
 =?iso-8859-1?Q?9fV+wmcVAbJrODvcGTydruwObN7Wey/uu6Q0EGDeyJ5Z47uZsUogVrTgIj?=
 =?iso-8859-1?Q?719ptGmVU2lec5f7IKPx2IG89fWOZV4W2Xjorot3Pw7s/KDrvV4w2jL4Iv?=
 =?iso-8859-1?Q?oC8bqFU01nZpiAjRcg8FNdhbH1Py2pMnRUupbDfA57lN2d5loDjXj+CeYl?=
 =?iso-8859-1?Q?ymrVOjqBy6ySctTrvsP6qDvk79iacgle9AsgBooc9Gr3321GSJm25speML?=
 =?iso-8859-1?Q?QFM8cF+ZStJT0cMvfd82+b4C/gpxWRWwzkh4dd8N0FQwwzj+1Jf6USy4U+?=
 =?iso-8859-1?Q?Yiz+3LA+Vh4COK+DQ7Eo3yWKDzpNK0YJgOVuJOiGL+vAoekCMeHloW4HEN?=
 =?iso-8859-1?Q?yflSCbbXMSjkpwEcXagF4RiS459J0BBy11ka158raxGroNMq/rig3C8RSb?=
 =?iso-8859-1?Q?iFq5C2W2CDlPLgmndkrmcMS8hm9qG8P5H84EDlxDz7SJ5s9foeXoPzfRkz?=
 =?iso-8859-1?Q?qFUI/RFLqmxh8DdqJs5nhBjDrrC5JKOzD+kKHwIQbekM05pbd9reQVEQlc?=
 =?iso-8859-1?Q?AxE8IK5T3QsUavGzqKfhJm1I/RIva8pNZwxj1eqYdFIuZ9k4cQFkTSBN8I?=
 =?iso-8859-1?Q?620t+Okh41bwP26rlYAdksGx6wd5F7U22xhcmPgwuU/aAoX7+loQMSNw?=
 =?iso-8859-1?Q?=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b95b4452-5da2-47b9-cc5e-08dde67ef0a2
X-MS-Exchange-CrossTenant-AuthSource: PH3PPF9E162731D.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 22:05:03.5832
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ak+WsIY02pUdkf+UXsZ2WfeTrQQvWYxsjDB8t7ziu7+Ky4zsn3+q5jznspvLfEDGPsU6RgfQ/uOV+00ACrrdlA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR11MB8030
X-OriginatorOrg: intel.com

Edgecombe, Rick P wrote:
> On Thu, 2025-08-28 at 13:26 -0700, Sean Christopherson wrote:
> > Me confused.  This is pre-boot, not the normal fault path, i.e. blocking other
> > operations is not a concern.
> 
> Just was my recollection of the discussion. I found it:
> https://lore.kernel.org/lkml/Zbrj5WKVgMsUFDtb@google.com/
> 
> > 
> > If tdh_mr_extend() is too heavy for a non-preemptible section, then the current
> > code is also broken in the sense that there are no cond_resched() calls.  The
> > vast majority of TDX hosts will be using non-preemptible kernels, so without an
> > explicit cond_resched(), there's no practical difference between extending the
> > measurement under mmu_lock versus outside of mmu_lock.
> > 
> > _If_ we need/want to do tdh_mr_extend() outside of mmu_lock, we can and should
> > still do tdh_mem_page_add() under mmu_lock.
> 
> I just did a quick test and we should be on the order of <1 ms per page for the
> full loop. I can try to get some more formal test data if it matters. But that
> doesn't sound too horrible?
> 
> tdh_mr_extend() outside MMU lock is tempting because it doesn't *need* to be
> inside it.

I'm probably not following this conversation, so stupid question:  It
doesn't need to be in the lock because user space should not be setting up
memory and extending the measurement in an asynchronous way.  Is that
correct?

> But maybe a better reason is that we could better handle errors
> outside the fault. (i.e. no 5 line comment about why not to return an error in
> tdx_mem_page_add() due to code in another file).
> 
> I wonder if Yan can give an analysis of any zapping races if we do that.

When you say analysis, you mean detecting user space did something wrong
and failing gracefully?  Is that correct?

Ira

