Return-Path: <kvm+bounces-51135-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E63A6AEEC85
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 04:45:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 423C417F1EB
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 02:45:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 413541DF268;
	Tue,  1 Jul 2025 02:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nVklaFcd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01E011547E7;
	Tue,  1 Jul 2025 02:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751337922; cv=fail; b=PP6yaGnu2deJjEZULppkfDhiyJpKhBFs1DGU1O/a3v8gWYU3UH57WshNJ3jJFkfa76cCX7X05lFCXn/qUfqrrv2rW5dOqRqznmk56d6IUut+N0+cbzh6XwD7xm1/28beMGsVufWIUU0+rmrK7nl+XUS19xmWmpo9L7rg/z8DEf4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751337922; c=relaxed/simple;
	bh=8oyJmuCKMo3ORxK3Mlu+iAD3Doyfhn4hH9wZ8WOZUV4=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=WcUMERwq+SJJ0dBJeI+TYdfULGTQK6mjVUBStvhUA0ZKoo+WKDq6MldPeGnPva2Y/r+lXXwFcqNDdA8lH8gFgw7P1h6A6udplSupdf3z5Cdz4ozI8IbuTs2AAtHBvIZHw3zgXOWhbdSgPZ1soCOz6KQVl80oyGB6PkQ+CXdlCZg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nVklaFcd; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751337920; x=1782873920;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=8oyJmuCKMo3ORxK3Mlu+iAD3Doyfhn4hH9wZ8WOZUV4=;
  b=nVklaFcdpd9ecjOeZGwOhHQqCUham/JLwu5oEKU6mf+en8vSmVA4AoYo
   cjc1ukXMWWcFLKjK3YEfjltCz5uK9OLSvuhaBvWXHmLowyp2VRKPkbjs8
   gQE0TRoJaKvLQsvKBJwZi16VhrTPGX1FUwWKDSLbQcnDOpeJQP7nn8bOu
   L00gU+t3TBOmiUy6NXUV716SCrafP94yt+KMklIZvALLi6Sm7SCvY8Lzx
   16Pww097Q+dA/4xCc9oOGBeOe+LRhvNm96B7c3GkudWgktBWjHJLgh5xi
   tQyM+og7i93QH9DSvE6Hq20ab88YXZg1XOjk0i7HgV1fsHtrWNT9a2llO
   g==;
X-CSE-ConnectionGUID: tUjFDyHAQPK2XOkRf9DxHg==
X-CSE-MsgGUID: k/acvfEARy621PCZlC085w==
X-IronPort-AV: E=McAfee;i="6800,10657,11480"; a="56203216"
X-IronPort-AV: E=Sophos;i="6.16,279,1744095600"; 
   d="scan'208";a="56203216"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2025 19:44:59 -0700
X-CSE-ConnectionGUID: 4bO85a4tSsS8DPnaGHlh7g==
X-CSE-MsgGUID: W3FVKKUxSkynsm+lzj+5Fg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,279,1744095600"; 
   d="scan'208";a="177291484"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2025 19:44:58 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 30 Jun 2025 19:44:58 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 30 Jun 2025 19:44:58 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (40.107.96.43) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 30 Jun 2025 19:44:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=q06MtruzIOG4jam/NVyegyM+9Ihf8U9+ggm+zic9EXku0S50EgLNmPzftfxmrT+B8YrkH0rf7RcN7FpKIBz1RvYcJ4g2p3607iBEAXuf3TVYINci8E1Xxp02NYjJAGbx4s5e4REAf6PaGUu33MXogRObVhQ7ASPs7ZtX9Dp0mZY0oyX/5OrME7EBF7WkjWEfb77ynyb0ZNTNUJSZCWwarCwdM/sb8p8ecEPTxvoNs79Tg1kMhXg/ca3h0OLDc4OQuDg/DbrA+pVTEMhJF/HPkzudiEMbbo83liz57zr623veDtc0RO6d3NfXcelFQkAVWINRuaTDM+J5GCxseXNNSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q9xHQE9RqYfujYGF2oKbsjbu/0iEMd2WCBRNoWLyUPI=;
 b=pyqjTddO86Vsgipzagq5qdwBdBd+XYtXTgOtuYhbK2ZX+zyzbqrKlZD3lVPLQwJlzwBEjmTq6zXNFrdpicLvbXdJHz86x4e3TkDsrON7oPi6Acp/X5KGAGEMk8jR1TKumrhzS9ne2KOlY/Jf1bW7CPUYEqcyXA6mqDa8jTq0UUOkXDRbNcAijuu4Q3RoL1fjVfLqhn5SArSN6QtDqfs8NmnT2getGdb8H+aJ6VOVzauf0VneMCnsSLke9GxPYXxBnYWeEl9atD82sNTHoRXreKLh2cIueQd0lB9cOr8PE5LtTbvyvJZuE8HNglc3GP3eAwBLL79wQj+BDEgQL4P3ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SA3PR11MB7625.namprd11.prod.outlook.com (2603:10b6:806:305::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.25; Tue, 1 Jul
 2025 02:44:08 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%5]) with mapi id 15.20.8880.027; Tue, 1 Jul 2025
 02:44:08 +0000
Date: Tue, 1 Jul 2025 10:41:30 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Huang, Kai" <kai.huang@intel.com>, "Du, Fan"
	<fan.du@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"david@redhat.com" <david@redhat.com>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "vbabka@suse.cz" <vbabka@suse.cz>, "Li, Zhiquan1"
	<zhiquan1.li@intel.com>, "Shutemov, Kirill" <kirill.shutemov@intel.com>,
	"michael.roth@amd.com" <michael.roth@amd.com>, "seanjc@google.com"
	<seanjc@google.com>, "Weiny, Ira" <ira.weiny@intel.com>, "Peng, Chao P"
	<chao.p.peng@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"Annapurve, Vishal" <vannapurve@google.com>, "tabba@google.com"
	<tabba@google.com>, "jroedel@suse.de" <jroedel@suse.de>, "Miao, Jun"
	<jun.miao@intel.com>, "pgonda@google.com" <pgonda@google.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 09/21] KVM: TDX: Enable 2MB mapping size after TD is
 RUNNABLE
Message-ID: <aGNK2tO2W6+GWtt3@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <aFC8YThVdrIyAsuS@yzhao56-desk.sh.intel.com>
 <aFIIsSwv5Si+rG3Z@yzhao56-desk.sh.intel.com>
 <aFWM5P03NtP1FWsD@google.com>
 <7312b64e94134117f7f1ef95d4ccea7a56ef0402.camel@intel.com>
 <aFp2iPsShmw3rYYs@yzhao56-desk.sh.intel.com>
 <a6ffe23fb97e64109f512fa43e9f6405236ed40a.camel@intel.com>
 <aFvBNromdrkEtPp6@yzhao56-desk.sh.intel.com>
 <0930ae315759558c52fd6afb837e6a8b9acc1cc3.camel@intel.com>
 <aF0Kg8FcHVMvsqSo@yzhao56-desk.sh.intel.com>
 <dab82e2c91c8ad019cda835ef8d528a7101509fa.camel@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <dab82e2c91c8ad019cda835ef8d528a7101509fa.camel@intel.com>
X-ClientProxiedBy: SG2P153CA0020.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c7::7)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SA3PR11MB7625:EE_
X-MS-Office365-Filtering-Correlation-Id: c45d3dc9-826f-462f-1f69-08ddb84926ae
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7416014;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?24tU+jiTXtL+G2yBRjeP2+bRpvHoMjTARd3eJ1VXQRxq6MOduKa734efFt?=
 =?iso-8859-1?Q?CYJiJ81gA2ert//OExD5lp4tQ7VuIwGo6Rac3xdiqFidwaj29zdIqY+pTl?=
 =?iso-8859-1?Q?nkSYYFZLUan3ZDUZ1z4sL3bBzl2sJpaKmDHo9U0AvKu7jXiPJcxSQc70QZ?=
 =?iso-8859-1?Q?9wpqriZ7Sc2fpyB5mgrhvSCEqje7b68B7l+Cd18Swd5LfmbB1H+IFaQ4/n?=
 =?iso-8859-1?Q?AxtgwClhkoQXUdP0YQk5b5IlgOpdamQHFe5v755XVeb7X9CPjD8+iFm2Fy?=
 =?iso-8859-1?Q?Wc5Qt2lg4p62fm+rZm7memRipxXvLFMAQAFjLkCD2r2DWwMR7bzoaFhsPR?=
 =?iso-8859-1?Q?K8gtBCqSDSzqjKElLCV5XapEuE8pB7y3Gr4NmKjKde9Raod6RcYHDTwKS3?=
 =?iso-8859-1?Q?3Knl+Dzz8tTKjn+vK00+sFbwM6sYZYw0QJUCV91ul79ajfkUBHGHgWYNSe?=
 =?iso-8859-1?Q?rikUjDmH+DGx+Y2yn0hhLq1KWphHak0rY6lWWjzicuQ4usjXxv7qPTXWdA?=
 =?iso-8859-1?Q?jADQmPEoW1qFeG8jqUiOJns+yPOHgPLTRamyC9rpmT1ocEa6MIMndaYx+y?=
 =?iso-8859-1?Q?flneIEk7f1QL7Z85sAZQXT0BnRiKjTNntExYCJn4CETXOwd9vxqNbNibm/?=
 =?iso-8859-1?Q?Z7SaPDEoh3qF5Egh3oS5pu4LWEyu75uf634+spJg/sfgwix4uVvwGuEif/?=
 =?iso-8859-1?Q?ngMPX6j4oP8P/vLXkN+dr6icjv3aTowUK9c5DrYyq8J1nymGJne+KG6+s6?=
 =?iso-8859-1?Q?tKS2GdN+bfzkVo7bHkJt4EY/X9LSsS20YWPLNCGYLktS12OybfrmWJY9IO?=
 =?iso-8859-1?Q?NAiX/kE5ktfF/S3FBXZGkaL+XiC08kofWrkFsdTVV4pDWL6IJMIbS7P6xu?=
 =?iso-8859-1?Q?z75jWsWwx/DtvIvNub4jFr0uu4kZN8N7VwRGRv7xomy0fBfsjH/qWK0Wwo?=
 =?iso-8859-1?Q?vfHF+YGbI2x9x/mYd6/r+8bEuNzH+P56f0vYFkDzyTUOaWo2PKM3ikDoet?=
 =?iso-8859-1?Q?T5pMhi66eaHHuLG0Lic3W192gHY8lsFeQG0xFFSg63wZoO8Z+ps16eQoAm?=
 =?iso-8859-1?Q?BRCK3N4E3CZwB4F2xahBucCSb36j66mh4gWDGAHBcJudt18n0lwUupi8ly?=
 =?iso-8859-1?Q?cKwoISH0F04a6mh2WI5QE/DSizprSV6xOY4wjjOgAI4abxk0XgVLJoAbmW?=
 =?iso-8859-1?Q?vLKL1eX954pdBSy1mXPOM5PPoMvejKWB5mndnzaeccIleIBtC1VBqzGkhw?=
 =?iso-8859-1?Q?wgk0VX4ZxMipkktpqciD/HtM6V4yt4ygDRhmllDMWUtFe1mI03MzmAi0cM?=
 =?iso-8859-1?Q?LMSDGwBRs7ujjMJV3ebIJqbxR10qsXSop+0ZBJbD12skRBhQc/Tlej1Gc5?=
 =?iso-8859-1?Q?hUNWAV0fpw8AFvRvL0SmOkeojFKfcUF5gp9vvwqUQinNtK1/wKVnUGdh8U?=
 =?iso-8859-1?Q?jIjKPaY8U81FOGjWPERYPqSirIzIGeq76TKF0dBsA1Z/PJcRZxJ1zvOn2e?=
 =?iso-8859-1?Q?Q=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?eMmxYpRRu/jTRQLbsWNB1rhgGr4iMPjA3q8I35MYGXIY8qhcafOVT3pw0c?=
 =?iso-8859-1?Q?79RIFdr1A4MrIaZb9xupqLeOpb2xhL75w1wUOZ7G5xRl2/lTGlaXoOL7Ej?=
 =?iso-8859-1?Q?iDhcrYWEXmm9h4XiZXaCKTDbXMvKssIZf/ZMc6521UaHCG4pHDKTfeiA/Q?=
 =?iso-8859-1?Q?zYmUODofDL+D4dDni2QcgAQEoqse6LZpl3+c79rSkXxHV+4L+JLwYpXjXp?=
 =?iso-8859-1?Q?gl/PusGPmebd662zHCFNl1vuuuFQElRxHhxsnFy2IwvAx9w0LCx0NrunnW?=
 =?iso-8859-1?Q?HOb/NAf/wOlrrvk3WPypGpOoQ5+xBnTmSFQ0MxilzsSwJ7or8+bUwvrNXQ?=
 =?iso-8859-1?Q?iptqGWY3jls3Dlyba5kmcQF9ef2MHafePXnW78Vv+N/XsefbiUB4nHKhvJ?=
 =?iso-8859-1?Q?ZD5MLoPFdhKoa5IQjQCHH7otg/HxUWZlFj88AcDqpXvEVh0DT41590sP9A?=
 =?iso-8859-1?Q?DzKWvEzXL9Xw2sF8cBXBx6e8FTl4f8ev4x1rscU5jmtJ2q9fOVTBXGbI+d?=
 =?iso-8859-1?Q?s5VaBxos4a5JKXsnAhhZmqK/XrJR6fdOdgkq9N/eW3nJI1kZlCsIWI1WK8?=
 =?iso-8859-1?Q?w2ReQ8ZFpl92KK4rka6RM6h5Uyg5mNmHcD10w0axXhW5Mh+7wsKTKk0Zrt?=
 =?iso-8859-1?Q?Ae3IwRkyGUyO5l7LdfFy6NDvHPru6rqk1g3z5WA60/z1/I/TvX54ekbVfw?=
 =?iso-8859-1?Q?HDkxXPjL1uhPnGc+ITUM/meb1WL/U3qBPlohYXGjAfLrzYYeb/POeS2Rp2?=
 =?iso-8859-1?Q?HnLscUxhfp9deade9ejTdVVDRL9tPiywNykfFjBFa/R0PinH/qGy5v+A0P?=
 =?iso-8859-1?Q?KrFG9NFgn0TtX0EnnBi18O49IRKIrn6fkLvwDClFimTry9yEiHNwio1KEF?=
 =?iso-8859-1?Q?MasUKNCFWTmFT5gDJ2p0li8z1xGI5X7pFJkve341x8xLY2rSOGm9p7gDkm?=
 =?iso-8859-1?Q?IyAcPLE3iLr4tlwpZxiUjKX0jxfoJC+RfmLdybQ4X/VD4wIULjGzjkuv0H?=
 =?iso-8859-1?Q?nLddyjwgJ15IleXjx3aqr2f/Uzq3g/VBVpjJ1MyFwzkT84dXqsK2gFo1yX?=
 =?iso-8859-1?Q?BIQCWJJZgY566NyzsVq7E4nCkTf1P4GgymXoXblQ+Uy8haZrRNi7gv8wvg?=
 =?iso-8859-1?Q?EeqF6opOS2dNc5U8wcdP4BTDPqm3T3ZPtWMzUcSswgeSef9iqG8aaRnlW+?=
 =?iso-8859-1?Q?qdclkCKSl06jvSqQcZChynPLtn5AG+3HVHtkOo2bdjzvY5qVfOqRx5X5fA?=
 =?iso-8859-1?Q?LWIGpgFCdQy3v8DFRB09Mnpj7cLlUV2q3HVHm1IVK2E+7p9ZTigkd5MiK/?=
 =?iso-8859-1?Q?Qndnw5a3E6TkKU58L/TFwvY0t78+m1CkJ+d1Gqv0LH6ETKPrM/RgdRP48S?=
 =?iso-8859-1?Q?h6GnlthkAzC74tU4zoGVuZ3dqgYaQHUdVYzB+c8aM/X1GcRy0Xusy8jsC/?=
 =?iso-8859-1?Q?BUjfAaeZVMf2htlqTvB2ss7pyP0fmoDCzDPlRgVP+RUXsdG67JV/Gn9CxE?=
 =?iso-8859-1?Q?VS623sHR/wybobGzQc49VNEbSU4zqKf9XOsQ40zOw6rs7Bi8OpRqNoscU7?=
 =?iso-8859-1?Q?noyi5ANqlwr0mO+iKRufatplhFeDAy/rgStkBJ930kB01CTNukCXRHlYZQ?=
 =?iso-8859-1?Q?tBfRbCBAZZj6HAE/sW6JggG0H7BpPq4I8v?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c45d3dc9-826f-462f-1f69-08ddb84926ae
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2025 02:44:08.0248
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B6iNBDaRbWtFiLHnFDD90cA6uFCb52xpEg0VG2ID1tlmH1iwKucv9FHn2dYSDZF73D57YOvVUKo9tLXsC7gMJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7625
X-OriginatorOrg: intel.com

On Tue, Jul 01, 2025 at 08:42:33AM +0800, Edgecombe, Rick P wrote:
> On Thu, 2025-06-26 at 16:53 +0800, Yan Zhao wrote:
> > On Wed, Jun 25, 2025 at 10:47:47PM +0800, Edgecombe, Rick P wrote:
> > > On Wed, 2025-06-25 at 17:28 +0800, Yan Zhao wrote:
> > > > On Wed, Jun 25, 2025 at 02:35:59AM +0800, Edgecombe, Rick P wrote:
> > > > > On Tue, 2025-06-24 at 17:57 +0800, Yan Zhao wrote:
> > > > > 
> > > > I guess it's the latter one as it can avoid modification to both EDK2 and Linux
> > > > guest.  I observed ~2710 instances of "guest accepts at 4KB when KVM can map at
> > > > 2MB" during the boot-up of a TD with 4GB memory.
> > > 
> > > Oh, wow that is more than I expected. Did you notice how many vCPUs they were
> > > spread across? What memory size did you use? What was your guest memory
> > > configuration?
> > The guest memory is 4GB, 8 vCPUs.
> > The memory slots layout is:
> > slot 1: base gfn=0, npages=0x80000
> > slot 2: base gfn=0x100000, npages=0x80000
> > slot 3: base gfn=0xffc00, npages=0x400
> > 
> > The GFN spread for the ~2710 instances is:
> > GFNs 0x806-0x9ff (1 time for each of 506 pages)
> > GFNs 0x7e800-0x7e9ff (1 time for each of 512 pages)
> > GFN: 0x7d3ff~0x7e7fe (repeated private-to-shared, and shared-to-private are
> >                       conducted on this range), with the top 3 among them being:
> >      0x7d9da (476 times)
> >      0x7d9d9 (156 times)
> >      0x7d9d7 (974 times)
> > 
> > All those instances are from vCPU 0, when the guest is in EDK2 and during early
> > kernel boot.
> > 
> > Based on my observation, the count of these instances does not scale with guest
> > memory. In other words, the count remains roughly the same even when the guest
> > memory is increased to 8GB.
> 
> So the impact would be negligible. The mmu write lock would not meet much, if
> any, contention.
> 
> > 
> > > > But does it mean TDX needs to hold write mmu_lock in the EPT violation handler
> > > > and set KVM_LPAGE_GUEST_INHIBIT on finding a violation carries 4KB level info?
> > > 
> > > I think so. I didn't check the reason, but the other similar code took it. Maybe
> > > not? If we don't need to take mmu write lock, then this idea seems like a clear
> > > winner to me.
> > Hmm,  setting KVM_LPAGE_GUEST_INHIBIT needs trying splitting to be followed.
> > So, if we don't want to support splitting under read mmu_lock, we need to take
> > write mmu_lock.
> > 
> > I drafted a change as below (will refine some parts of it later).
> > The average count to take write mmu_lock is 11 during VM boot.
> > 
> > There's no signiticant difference in the count of 2M mappings
> > During guest kerne booting to login, on average: 
> > before this patch: 1144 2M mappings 
> > after this patch:  1143 2M mappings.
> 
> Oh, hmm. Well, it's not strong argument against.
> 
> > 
> > diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> > index f999c15d8d3e..d4e98728f600 100644
> > --- a/arch/x86/kvm/mmu.h
> > +++ b/arch/x86/kvm/mmu.h
> > @@ -322,4 +322,8 @@ static inline bool kvm_is_gfn_alias(struct kvm *kvm, gfn_t gfn)
> >  {
> >         return gfn & kvm_gfn_direct_bits(kvm);
> >  }
> > +
> > +void hugepage_set_guest_inhibit(struct kvm_memory_slot *slot, gfn_t gfn, int level);
> > +bool hugepage_test_guest_inhibit(struct kvm_memory_slot *slot, gfn_t gfn, int level);
> > +
> >  #endif
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index f0afee2e283a..28c511d8b372 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -721,6 +721,8 @@ static struct kvm_lpage_info *lpage_info_slot(gfn_t gfn,
> >   */
> >  #define KVM_LPAGE_MIXED_FLAG   BIT(31)
> > 
> > +#define KVM_LPAGE_GUEST_INHIBIT_FLAG   BIT(30)
> > +
> >  static void update_gfn_disallow_lpage_count(const struct kvm_memory_slot *slot,
> >                                             gfn_t gfn, int count)
> >  {
> > @@ -732,7 +734,8 @@ static void update_gfn_disallow_lpage_count(const struct kvm_memory_slot *slot,
> > 
> >                 old = linfo->disallow_lpage;
> >                 linfo->disallow_lpage += count;
> > -               WARN_ON_ONCE((old ^ linfo->disallow_lpage) & KVM_LPAGE_MIXED_FLAG);
> > +               WARN_ON_ONCE((old ^ linfo->disallow_lpage) &
> > +                             (KVM_LPAGE_MIXED_FLAG | KVM_LPAGE_GUEST_INHIBIT_FLAG));
> >         }
> >  }
> > 
> > @@ -1653,13 +1656,15 @@ int kvm_split_boundary_leafs(struct kvm *kvm, struct kvm_gfn_range *range)
> >         bool ret = 0;
> > 
> >         lockdep_assert_once(kvm->mmu_invalidate_in_progress ||
> > -                           lockdep_is_held(&kvm->slots_lock));
> > +                           lockdep_is_held(&kvm->slots_lock) ||
> > +                           srcu_read_lock_held(&kvm->srcu));
> > 
> >         if (tdp_mmu_enabled)
> >                 ret = kvm_tdp_mmu_gfn_range_split_boundary(kvm, range);
> > 
> >         return ret;
> >  }
> > +EXPORT_SYMBOL_GPL(kvm_split_boundary_leafs);
> > 
> >  bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
> >  {
> > @@ -7734,6 +7739,18 @@ void kvm_mmu_pre_destroy_vm(struct kvm *kvm)
> >                 vhost_task_stop(kvm->arch.nx_huge_page_recovery_thread);
> >  }
> > 
> > +bool hugepage_test_guest_inhibit(struct kvm_memory_slot *slot, gfn_t gfn, int level)
> > +{
> > +       return lpage_info_slot(gfn, slot, level)->disallow_lpage & KVM_LPAGE_GUEST_INHIBIT_FLAG;
> > +}
> > +EXPORT_SYMBOL_GPL(hugepage_test_guest_inhibit);
> > +
> > +void hugepage_set_guest_inhibit(struct kvm_memory_slot *slot, gfn_t gfn, int level)
> > +{
> > +       lpage_info_slot(gfn, slot, level)->disallow_lpage |= KVM_LPAGE_GUEST_INHIBIT_FLAG;
> > +}
> > +EXPORT_SYMBOL_GPL(hugepage_set_guest_inhibit);
> > +
> >  #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
> >  static bool hugepage_test_mixed(struct kvm_memory_slot *slot, gfn_t gfn,
> >                                 int level)
> > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > index 244fd22683db..4028423cf595 100644
> > --- a/arch/x86/kvm/vmx/tdx.c
> > +++ b/arch/x86/kvm/vmx/tdx.c
> > @@ -1852,28 +1852,8 @@ int tdx_sept_split_private_spt(struct kvm *kvm, gfn_t gfn, enum pg_level level,
> >         if (KVM_BUG_ON(to_kvm_tdx(kvm)->state != TD_STATE_RUNNABLE || level != PG_LEVEL_2M, kvm))
> >                 return -EINVAL;
> > 
> > -       /*
> > -        * Split request with mmu_lock held for reading can only occur when one
> > -        * vCPU accepts at 2MB level while another vCPU accepts at 4KB level.
> > -        * Ignore this 4KB mapping request by setting violation_request_level to
> > -        * 2MB and returning -EBUSY for retry. Then the next fault at 2MB level
> > -        * would be a spurious fault. The vCPU accepting at 2MB will accept the
> > -        * whole 2MB range.
> > -        */
> > -       if (mmu_lock_shared) {
> > -               struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
> > -               struct vcpu_tdx *tdx = to_tdx(vcpu);
> > -
> > -               if (KVM_BUG_ON(!vcpu, kvm))
> > -                       return -EOPNOTSUPP;
> > -
> > -               /* Request to map as 2MB leaf for the whole 2MB range */
> > -               tdx->violation_gfn_start = gfn_round_for_level(gfn, level);
> > -               tdx->violation_gfn_end = tdx->violation_gfn_start + KVM_PAGES_PER_HPAGE(level);
> > -               tdx->violation_request_level = level;
> > -
> > -               return -EBUSY;
> > -       }
> > +       if (mmu_lock_shared)
> > +               return -EOPNOTSUPP;
> > 
> >         ret = tdx_sept_zap_private_spte(kvm, gfn, level, page);
> >         if (ret <= 0)
> > @@ -1937,28 +1917,51 @@ static inline bool tdx_is_sept_violation_unexpected_pending(struct kvm_vcpu *vcp
> >         return !(eq & EPT_VIOLATION_PROT_MASK) && !(eq & EPT_VIOLATION_EXEC_FOR_RING3_LIN);
> >  }
> > 
> > -static inline void tdx_get_accept_level(struct kvm_vcpu *vcpu, gpa_t gpa)
> > +static inline int tdx_check_accept_level(struct kvm_vcpu *vcpu, gpa_t gpa)
> >  {
> >         struct vcpu_tdx *tdx = to_tdx(vcpu);
> > +       struct kvm *kvm = vcpu->kvm;
> > +       gfn_t gfn = gpa_to_gfn(gpa);
> > +       struct kvm_memory_slot *slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
> >         int level = -1;
> > +       u64 eeq_info;
> > 
> > -       u64 eeq_type = tdx->ext_exit_qualification & TDX_EXT_EXIT_QUAL_TYPE_MASK;
> > +       if (!slot)
> > +               return 0;
> > 
> > -       u32 eeq_info = (tdx->ext_exit_qualification & TDX_EXT_EXIT_QUAL_INFO_MASK) >>
> > -                       TDX_EXT_EXIT_QUAL_INFO_SHIFT;
> > +       if ((tdx->ext_exit_qualification & TDX_EXT_EXIT_QUAL_TYPE_MASK) !=
> > +           TDX_EXT_EXIT_QUAL_TYPE_ACCEPT)
> > +               return 0;
> > 
> > -       if (eeq_type == TDX_EXT_EXIT_QUAL_TYPE_ACCEPT) {
> > -               level = (eeq_info & GENMASK(2, 0)) + 1;
> > +       eeq_info = (tdx->ext_exit_qualification & TDX_EXT_EXIT_QUAL_INFO_MASK) >>
> > +                   TDX_EXT_EXIT_QUAL_INFO_SHIFT;
> > 
> > -               tdx->violation_gfn_start = gfn_round_for_level(gpa_to_gfn(gpa), level);
> > -               tdx->violation_gfn_end = tdx->violation_gfn_start + KVM_PAGES_PER_HPAGE(level);
> > -               tdx->violation_request_level = level;
> > -       } else {
> > -               tdx->violation_gfn_start = -1;
> > -               tdx->violation_gfn_end = -1;
> > -               tdx->violation_request_level = -1;
> > +       level = (eeq_info & GENMASK(2, 0)) + 1;
> > +
> > +       if (level == PG_LEVEL_4K) {
> > +              if (!hugepage_test_guest_inhibit(slot, gfn, PG_LEVEL_2M)) {
> > +                       struct kvm_gfn_range gfn_range = {
> > +                               .start = gfn,
> > +                               .end = gfn + 1,
> > +                               .slot = slot,
> > +                               .may_block = true,
> > +                               .attr_filter = KVM_FILTER_PRIVATE,
> > +                       };
> > +
> > +                       scoped_guard(write_lock, &kvm->mmu_lock) {
> > +                               int ret;
> > +
> > +                               ret = kvm_split_boundary_leafs(kvm, &gfn_range);
> > +
> > +                               if (ret)
> > +                                       return ret;
> > +
> > +                               hugepage_set_guest_inhibit(slot, gfn, PG_LEVEL_2M);
> 
> 
> Can you explain what you found regarding the write lock need?
Here, the write lock protects 2 steps:
(1) update lpage_info.
(2) try splitting if there's any existing 2MB mapping.

The write mmu_lock is needed because lpage_info is read under read mmu_lock in
kvm_tdp_mmu_map().

kvm_tdp_mmu_map
  kvm_mmu_hugepage_adjust
    kvm_lpage_info_max_mapping_level

If we update the lpage_info with read mmu_lock, the other vCPUs may map at a
stale 2MB level even after lpage_info is updated by hugepage_set_guest_inhibit().

Therefore, we must perform splitting under the write mmu_lock to ensure there
are no 2MB mappings after hugepage_set_guest_inhibit().

Otherwise, during later mapping in __vmx_handle_ept_violation(), splitting at
fault path could be triggered as KVM MMU finds the goal level is 4KB while an
existing 2MB mapping is present.


> For most accept
> cases, we could fault in the PTE's on the read lock. And in the future we could

The actual mapping at 4KB level is still with read mmu_lock in
__vmx_handle_ept_violation().

> have a demote that could work under read lock, as we talked. So
> kvm_split_boundary_leafs() often or could be unneeded or work under read lock
> when needed.
Could we leave the "demote under read lock" as a future optimization? 


> What is the problem in hugepage_set_guest_inhibit() that requires the write
> lock?
As above, to avoid the other vCPUs reading stale mapping level and splitting
under read mmu_lock.

As guest_inhibit is set one-way, we could test it using
hugepage_test_guest_inhibit() without holding the lock. The chance to hold write
mmu_lock for hugepage_set_guest_inhibit() is then greatly reduced.
(in my testing, 11 during VM boot).
 
> But in any case, it seems like we have *a* solution here. It doesn't seem like
> there are any big downsides. Should we close it?
I think it's good, as long as Sean doesn't disagree :)


> > +                       }
> > +              }
> >         }
> > +
> > +       return 0;
> >  }
> > 
> >  static int tdx_handle_ept_violation(struct kvm_vcpu *vcpu)
> > @@ -1987,7 +1990,8 @@ static int tdx_handle_ept_violation(struct kvm_vcpu *vcpu)
> >                  */
> >                 exit_qual = EPT_VIOLATION_ACC_WRITE;
> > 
> > -               tdx_get_accept_level(vcpu, gpa);
> > +               if (tdx_check_accept_level(vcpu, gpa))
> > +                       return RET_PF_RETRY;
> > 
> >                 /* Only private GPA triggers zero-step mitigation */
> >                 local_retry = true;
> > @@ -3022,9 +3026,6 @@ static int tdx_td_vcpu_init(struct kvm_vcpu *vcpu, u64 vcpu_rcx)
> > 
> >         vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
> > 
> > -       tdx->violation_gfn_start = -1;
> > -       tdx->violation_gfn_end = -1;
> > -       tdx->violation_request_level = -1;
> >         return 0;
> > 
> >  free_tdcx:
> > @@ -3373,14 +3374,9 @@ int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
> >  int tdx_gmem_private_max_mapping_level(struct kvm_vcpu *vcpu, kvm_pfn_t pfn,
> >                                        gfn_t gfn, bool prefetch)
> >  {
> > -       struct vcpu_tdx *tdx = to_tdx(vcpu);
> > -
> > -       if (unlikely((to_kvm_tdx(vcpu->kvm)->state != TD_STATE_RUNNABLE) || prefetch))
> > +       if (unlikely((to_kvm_tdx(vcpu->kvm)->state != TD_STATE_RUNNABLE)))
> >                 return PG_LEVEL_4K;
> > 
> > -       if (gfn >= tdx->violation_gfn_start && gfn < tdx->violation_gfn_end)
> > -               return tdx->violation_request_level;
> > -
> >         return PG_LEVEL_2M;
> >  }
> > 
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index acd18a01f63d..3a3077666ee6 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -2610,6 +2610,7 @@ struct kvm_memory_slot *kvm_vcpu_gfn_to_memslot(struct kvm_vcpu *vcpu, gfn_t gfn
> > 
> >         return NULL;
> >  }
> > +EXPORT_SYMBOL_GPL(kvm_vcpu_gfn_to_memslot);
> > 
> >  bool kvm_is_visible_gfn(struct kvm *kvm, gfn_t gfn)
> >  {
> 

