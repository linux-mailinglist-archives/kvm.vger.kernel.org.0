Return-Path: <kvm+bounces-49338-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 41588AD7FA1
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 02:26:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B23F33B4142
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 00:25:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92A2D1C4A17;
	Fri, 13 Jun 2025 00:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nmzIQie6"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC9F52AD04;
	Fri, 13 Jun 2025 00:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749774364; cv=fail; b=FAeiqwcfz0+eMozCvhfP+1v3ZLSmqPUC94HbNt8wH5g58hSdUkSxqsng83svI6Scf2GznQmZnYC8P+wBJsFE6hoWHVLRiAB0Con+wMD29FpVRJMFGtrYSV/9BOTw4AJXAgNX2vLMWVyLXmmu8ZkScwzk1fCpF0BwuhkUJTjakTM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749774364; c=relaxed/simple;
	bh=fqhWOy7hqjoKLjqByJvAlg3mUgEJewKN3V7K5jiBhPY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=P/V1HWRdZAwRuYvuxqiBDLLcp/28wKuphA2h/wmrDs6E3g/Tv/fVYtJ1/r6+NmOtJZGiYkf4VxMZ77hFHt31o6kU98czM1p4azvMO81WAUnacAy0hc2PQebgsGNHOPDBq9fYgvWZesileqF6NHtQOOACgfpjJtEi/X1S0jtvG6I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nmzIQie6; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749774363; x=1781310363;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=fqhWOy7hqjoKLjqByJvAlg3mUgEJewKN3V7K5jiBhPY=;
  b=nmzIQie6jZsrYcaQ4H1FSGR6IrCE8DUobZQkWsg5pY+PwPuYi9GB9kpL
   nl59T3j3kOfESvoxQInAtfpTIbHOS5UKjq3Tvch0yg37rQGaaBpybNfUd
   0huYQfHv70c4i6BcEr4RzjZJsGqnQH9qzsF6oNHeUPFXA1k/dZm6+T7vb
   +cYoPiEwLm8ok7SGXZv3kO6RRra0JzKz8GRtpjRRoZtTXDKHa8ggcu1Jj
   HzWhWSg4nktKImi9QtpFEoBEohqLeWQ2jwsMsK4Y34BgtERIQVpE2sR00
   NZpLWo3PcWSRdj3nmw9UWAOegXfTQZ4yQ+pCJ6IGYRSQRHcJdLaPJ1qGY
   A==;
X-CSE-ConnectionGUID: /8hDhyCVRJ2opp8Rmf7oCw==
X-CSE-MsgGUID: B+b2kifrQZ2kGcnxKseU8g==
X-IronPort-AV: E=McAfee;i="6800,10657,11462"; a="63331102"
X-IronPort-AV: E=Sophos;i="6.16,232,1744095600"; 
   d="scan'208";a="63331102"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2025 17:26:02 -0700
X-CSE-ConnectionGUID: 48TUjYs4TdebQTVg9kvexQ==
X-CSE-MsgGUID: qEgA3xWfR5+3//7LgPU4WQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,232,1744095600"; 
   d="scan'208";a="147657092"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2025 17:26:01 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 12 Jun 2025 17:26:01 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 12 Jun 2025 17:26:01 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.54)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 12 Jun 2025 17:26:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MHOW6Ki0xH1rD+3nt/5yYkpodLBjXTfslUIBvFjATVYo27DwX5lcl0BdQ9jWf5hKgwDoXW+hG94Ybum/87J+O9e7VghW4s8dCBWvdaUJ92f4pZxsS1n6BZJons9IeqyE3eU6IgkNkZqqB7gDs12tSiXslBK9ocSWBlNngdCCwwg7RO6qg9rVnBMy+MqVth0Qtc6I9GLtfa4o/qMzRoquUPXzeUbqHgWiKY7X49JVMW7Mwxroyv7p+l+/kvrNzl8qR1akXjfLAfum8tYBcI/G2yaAdNoU3FIOcK5Fb+n1D+1PUyJY9VmR+dAfYwlOlwIwe1OhGpa+XbKKNJL9EbRouQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fqhWOy7hqjoKLjqByJvAlg3mUgEJewKN3V7K5jiBhPY=;
 b=f+UgrRAu/2QEkv4fnsNYbrpnSBQcwQaTlj3Xa2KvkgEn/dho2BhwQZjNxBo6QGMrg3ponRMI1DMv9nQ6J8O84aJkZUW0wIw8DNRoO/MqkVYuMtUHtWpPt2zQGSpKEvuMmvJUzmRZmZpTT5X27IVr1sWyDFXXdz5S6ryn61CTDR8yNtkULtZPDt3ZhLFE04CncIqcR9gGCsnyEzJuhqgfVZ8tRNcRPj3RV5fgXaFya+VQ4JUbivPsn1+XRJ0rQWtq1p7cveAiqj+gGedWymnFJjVhOWOS3pPDYWTDy6vOmecIt9qFVFBzkXTWJQfG64Llb6GAghXm3bI8N362iDbp1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by IA1PR11MB7680.namprd11.prod.outlook.com (2603:10b6:208:3fb::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.19; Fri, 13 Jun
 2025 00:25:58 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8813.024; Fri, 13 Jun 2025
 00:25:58 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Huang, Kai" <kai.huang@intel.com>, "Du, Fan"
	<fan.du@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"david@redhat.com" <david@redhat.com>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>, "Li,
 Zhiquan1" <zhiquan1.li@intel.com>, "Shutemov, Kirill"
	<kirill.shutemov@intel.com>, "michael.roth@amd.com" <michael.roth@amd.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Weiny, Ira"
	<ira.weiny@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, "Peng,
 Chao P" <chao.p.peng@intel.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "vbabka@suse.cz" <vbabka@suse.cz>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "tabba@google.com" <tabba@google.com>,
	"Annapurve, Vishal" <vannapurve@google.com>, "jroedel@suse.de"
	<jroedel@suse.de>, "Miao, Jun" <jun.miao@intel.com>, "pgonda@google.com"
	<pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 09/21] KVM: TDX: Enable 2MB mapping size after TD is
 RUNNABLE
Thread-Topic: [RFC PATCH 09/21] KVM: TDX: Enable 2MB mapping size after TD is
 RUNNABLE
Thread-Index: AQHbtMYisXlDVaH8LEKqVl1+c9iQ77PRHICAgAN/mYCAAIg5AIAA1+mAgAPLQICAAIwTAIABF74AgADuIICAIfsagIACKESAgAALWQCAAAHGgA==
Date: Fri, 13 Jun 2025 00:25:58 +0000
Message-ID: <d9bf81fc03cb0d92fc0956c6a49ff695d6b2d1ad.camel@intel.com>
References: <dc20a7338f615d34966757321a27de10ddcbeae6.camel@intel.com>
	 <c19b4f450d8d079131088a045c0821eeb6fcae52.camel@intel.com>
	 <aCcIrjw9B2h0YjuV@yzhao56-desk.sh.intel.com>
	 <c98cbbd0d2a164df162a3637154cf754130b3a3d.camel@intel.com>
	 <aCrsi1k4y8mGdfv7@yzhao56-desk.sh.intel.com>
	 <f9a2354f8265efb9ed99beb871e471f92adf133f.camel@intel.com>
	 <aCxMtjuvYHk2oWbc@yzhao56-desk.sh.intel.com>
	 <119e40ecb68a55bdf210377d98021683b7bda8e3.camel@intel.com>
	 <aEmVa0YjUIRKvyNy@google.com>
	 <f001881a152772b623ff9d3bb6ca5b2f72034db9.camel@intel.com>
	 <aEtumIYPJSV49_jL@google.com>
In-Reply-To: <aEtumIYPJSV49_jL@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|IA1PR11MB7680:EE_
x-ms-office365-filtering-correlation-id: cb0bc70e-d530-4182-c507-08ddaa10de51
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?aFVMSDljMHFkQk4xNitkQWdZKzJWdC9vd3ZvYm9PZEp0Qlk1cnFJajFMdjdq?=
 =?utf-8?B?ZCsxRzNIWkt0ME5iR0dBdGdHRWd0SFRCU3B4TUZKWGhuRDBsRVRvR0t1ZXF1?=
 =?utf-8?B?WHJVc0JvZE5xQjgrM3Z4ZXlqN0s1MW5yNnBIR0o0Z002RUhOWjhEcTlLQXVJ?=
 =?utf-8?B?eDFhRVpkT1RGTlFrdlBjUDJmRnFsTDdmaTUvUlJoeWRsZHhqSVBzdkVBZ0Fh?=
 =?utf-8?B?YXV2Z1RhbXZhbzBpUG1JcGpoaVJhNGdYdHM5c29USWNxODBaaFFmNVNvNTg0?=
 =?utf-8?B?M1lOVWVjWEpNL3YvVkZaYWdyQkdUQnhvWXg3L0tUUC9rcHYyTmVSNGI5cnpr?=
 =?utf-8?B?RFpEVGlHQ05FaThjd3VRSituSFlsakd3aEhHclVQMnNJNTFPQUgzODVZS09q?=
 =?utf-8?B?eDV6cE1yUWV3K0pTdTZYSXo4dFZmeGRCWEJXdHUyeTJsUk12SFhKb244aXh5?=
 =?utf-8?B?UGhkR0dwL295ZHJ6UXpQVUN2T29lMENNYlZGR2NoQSt5dHNKcFNuQXFER1Vs?=
 =?utf-8?B?SnoxNW9NQnIwZDV3RUxVaDUrdlIrRXdsOWN1RXlXNUxoR3pkWkZUSUJVVVF6?=
 =?utf-8?B?UVJTam4yUFhZbHRRbW9DWUJSSDhiUUxBQ1ZOdzFrc05ZMnd1QlgzdThoQ1JV?=
 =?utf-8?B?cW45MWlzZGZ2N1dvOHl6cVBSdkxHY3U4MWVqeU01Z21yVy9Tb2VXUmdnbUFl?=
 =?utf-8?B?L2x5L3J0V215SUw5NHlPVW9tZG9MeDF4NFhuR0RVS1JtMXYrZUtReHBPQXFp?=
 =?utf-8?B?OFBqNDVsVEZISkxmemlXRGRjY2VDN3FiMkJzUXRmOSt1bHlPd1FDVEFxTFlS?=
 =?utf-8?B?b3YzMGtrSjFySitvTTNqbzBWQmk4eHYxVDBQOW9HOFZrTm1SdWg0RkNjT3Fa?=
 =?utf-8?B?UXl5TDNFc1ZVNXUxdm5HTEJ6OEtSdnFhVUZ3M2xwT2twd3NlYXlDMlFzTmNU?=
 =?utf-8?B?VnpobXlUZE5oZ05HVjhkbU5HdzQ4OG5NYjAyaE5SV0dGRFZ4MXJDQU5DeW9U?=
 =?utf-8?B?ejB0YmRTSGRFdlc2ZTk3K1hlV3VObmRpSTRXWW1MOGNNUUlaU2Y4b0ZFcWRW?=
 =?utf-8?B?eTFjcm5vbmFLVEU2Nk8ybmNhME12RExtblpPUHMzR1dnOVBqcFdMc1BzYXcy?=
 =?utf-8?B?T3cyU0RxMEI4VkpKeWNhdktwK2N3WlBpZWh2bTEzeW5rUTg5blovNExHYUI0?=
 =?utf-8?B?UElub3dzeUg2U2NGSzh2WHBSLzNmNTNVcXpCTkQ2bUNyUXd3bW9uNzFYMnJR?=
 =?utf-8?B?Tmk3N1BvTEpkeCtGZi8vS1V1TU1MdVMxTUJ1ejluVUFhNXF2VmJmeStSRDBQ?=
 =?utf-8?B?TFZucXRsZ3lYWEE5OGhERDV3SUlaS2pvc3Q2eDZVT21Va21DTE5QVkdUU3BQ?=
 =?utf-8?B?MXJmOVVrME93TXppc2FBMEJaVlZ4ZzBCQlhqckpSSWdSMnRKM0l2d2tyQ2pQ?=
 =?utf-8?B?SXlUR0paR1hiNnFjQWg5cjk3Wkx4MGNpZG5lUklrZzVpd0VIUjFZTmQrZHpo?=
 =?utf-8?B?ZmhpRHpEOS9BYnNOVDRJK3dvNHVLUTF5bnRRSHpjY1h0aWt2bkE3T1VmdGQx?=
 =?utf-8?B?KzdwbVd5Mlpac2VHUExwekRUeEVZQ0ZvbWsxRmtHMDhPc0JQeDNERW1CeURt?=
 =?utf-8?B?dmhFNkltUnVrYkl0S1daY2V5SVBLZ1VQQ1ROTjZ4U2l5YWYxdmN6MW0ydDhJ?=
 =?utf-8?B?SjV1SmJnUGJoMzhzMlpqbFpRUFJ4WGszYit4QUhlVVBRbWVEWXgwVFAralMy?=
 =?utf-8?B?UU1JRmdoRmh4TlZySDc1aU9kYXZhQ1oyYjR0bmRVblkybXBLSk8zd3RNeVB5?=
 =?utf-8?B?QUEwTTZ5WmVaemhQcWRjZWE0SGYvUGJZUndncW40YUw3U2FzOVUyamN1b29z?=
 =?utf-8?B?Si9NdC9YNWRrRG5XTVRjZHd3NWVFa1ZvYWJCVUFqSWNQb1JqVXVFT04zL3dz?=
 =?utf-8?B?V1hsbzlMT2FHN3NSeXh5UDg0ZVo3RWxaKzVnRzNQZzhFM25qWmQ5VER2VHZT?=
 =?utf-8?B?UlpTajRiNHB3PT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?a1l5c3NWcXhRdVpYSUNJR055L2ovKzM4S0FnTG01b2FFcFpzMStRMFV5T1JY?=
 =?utf-8?B?S1dYK0o0QkV0MlpZbytkZjErODJWOXQ0ZW00ei8xTDB2cGZRM01GZmJMd1dS?=
 =?utf-8?B?U2twR1ZpOVF3ejZlSDN5Snp4dWRYVlJ0Nm9MMXkvbks3V3NTdlhOYkw5RGxo?=
 =?utf-8?B?a3UvVXFVTmF3VnV5d0w2V3dYamp3WmJ1QWpsSzh0UXhEbjhEa2xPMFF3Tith?=
 =?utf-8?B?bjFyN1lpWDB2TXoySi8wT1htdHZuamRmenBlMVNBM2wzc3ZFV0pVWVI4RHpN?=
 =?utf-8?B?RkZqM04wQ0x3Z3RrbzZkTFYwVUZVZHMwbE8wdFhUTUFmYWRTMmpaQ3RkQmZk?=
 =?utf-8?B?NzZxd0Qwd0Joek5KT1l4cHgydUMrYTIwRytzbzNxTFlsQ3FnWXhlOG1aUXha?=
 =?utf-8?B?WksxM1RsMmt4NHdidVNhaUt1VU9pM0E2UWVEME9zSnJkczcrc05wNFJIdTFW?=
 =?utf-8?B?NTBHSFloYWM4VllIaS9ZMnNad3dQUENualRyaktCRk51Y3FCR2NQVVl5b1cv?=
 =?utf-8?B?TklpM2QyOXgxenNuL0Z3ZDRHUm0ybWFaVU5hVVVyUm5PTWNtWTNBeEY0OG1a?=
 =?utf-8?B?SzM1VzlTOGQybkp3cWFqSWc2dkhCTlAvcnNoYjRiU05XYURhTWZ2WTl3VkJE?=
 =?utf-8?B?ek43bEJUWXN4M3VwNXNFNDdUaEg2eWorc1g0N0ROcmhhcklheWVKd1RjOHdl?=
 =?utf-8?B?eFpUZjZVRE1FNUt4Mm1qS0pRcHpsMHRkY0RWRDQrM281VXJPYnVRUmdUUEdE?=
 =?utf-8?B?WmVvOXFqa2tOWGI2dnhUT2QrNHBUd0lpczB3cWFBOGV6NWo5anZLbXdtd1hY?=
 =?utf-8?B?c0toeTUrUHNlQS9CMWt5ZUtMWFZSdHhxK0RWbURKWXpNblF5UC9zTjE2cnhF?=
 =?utf-8?B?aGhhczAvQVdFbTF3Z1FuVFhJTW5VTWxpcUJiYzc5K2xxQmtFZDFlNnN3YlpC?=
 =?utf-8?B?a2M5dEVkSW5qcU02aVJ1OGhJc0FlKy9wak9sWms0UE5hazNuOEt3dHRxV2xi?=
 =?utf-8?B?SjdzdVpHQlhPWU5YbUl2T2Z4MUdnTThzMSs1c04xK3FMOWtPWmtGUG16RFJM?=
 =?utf-8?B?YWswZ3F0L3FxdFowRFZHZkpwOXpEQjJCRndGeUtkMEN3eEJTUWI0eS9CNE00?=
 =?utf-8?B?MFJqVVpqRkZoVFJ5R1NkZm1waXo1b1MwYklUaC8xOXBVTW1valNndmNpSDAr?=
 =?utf-8?B?T2h1SE95SldRZzNsS0RqZkM3YmtGcnFvdlIrbmZaQ213WGlJSXFuVjVubXEw?=
 =?utf-8?B?Q29hbmM3Q2p5bEUwVmdJS01BZzF2NFNhK2puNVFVSTBSVmJSZmVPaWpCelJI?=
 =?utf-8?B?U2JlWWh5ZWxjbkJLK0l3OFRHVmRuaGRWOVBxYk1VL0dWMWJ6RnVkU1RJRmNv?=
 =?utf-8?B?WlNXYmZlc2w5RGFLTTM2c3o5R01IOU02M1JvczRENmgyUXRVTGtTbk5wQWdP?=
 =?utf-8?B?SmdHVDN5a2MzQ012ZTE0SUJSaW9kLzdGQUY0b2JWMUVLaFV1V21aQ29lYjBm?=
 =?utf-8?B?YnBORnhYcTZReDFDVWltRGZRb0VwVGp6YjAyOGl2elRzNWRlK3cvYmFlL0cy?=
 =?utf-8?B?Q0ZuOFMxL2gwcXpBc1ZvRWQxRkZlM1ZyejBEVFJUVW1udFQrbGRzUzZ0cHV0?=
 =?utf-8?B?RFF5QlhYNlJIcjlBNGxwUFdIK29FeThsS1R6UkNiaDRyRUZjbFpJR0YyYXYv?=
 =?utf-8?B?M3EvM25DRHMwcGpleTJzZzQwWHc2M2d1SFQwdnFyeEtGVUtIeVBHcFZtVytN?=
 =?utf-8?B?UnVlbkJSSXUxc1RLVnljZ29nYkp4SjlCVHRrNkFhdCtyekQrTE82YWw4SkQz?=
 =?utf-8?B?WWNnS3pKREo4bEVaTDdJMitZdklUQlkyd3oyMHJNUzR0MS9pVVg4NHp5WTIy?=
 =?utf-8?B?Z0RrTkU5QmRValFORStoUmRTNHBjWWRwcXB6Lzd0R00rdE1zRmZ6QWRiUzF1?=
 =?utf-8?B?OVY0MjFRc0JDWmlXaThvdWJtU0FnTjJhUGhwaTN5YndNSVV3eXF2UUNFMzVT?=
 =?utf-8?B?TnB1NEtYc0dRRFJiT2YwMlp2Wit0U3RrK041cWZyZyswaS9BWVN2SmpZbXUr?=
 =?utf-8?B?SDFGbEZQc09LeStoTnlHMVkxNWpvdU9Gc09QaEFvTWtkQnlic3A1WElzNytX?=
 =?utf-8?B?cWY3T2RtM1pyTlRNSTQ2aW9YZGR1SWF0aXIyQVpGdDkwTDNwTVRrbzh3VGJT?=
 =?utf-8?Q?LVbvNUa6AbxjhzbLVwbBjoY=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <46AF284D69991B4CBEC0BD78A2A69336@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb0bc70e-d530-4182-c507-08ddaa10de51
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jun 2025 00:25:58.2113
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NKzrYUbQE+kV2IV+1ijnrNnaPFxiTOyjN9aw/TuvgOkFw2MSNcT5+ftGIW2UD7dh33Z1puNO+6MeReGi17q0naB1Oko/2iLXK/HCo5IBKzM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7680
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA2LTEyIGF0IDE3OjE5IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiA+IEkgdGhpbmsgdGhpcyBtYXkgbmVlZCBhIGd1ZXN0IG9wdC1pbiwgc28gdGhlIGd1
ZXN0IGNhbiBzYXkgaXQgY2FuIGhhbmRsZQ0KPiA+IGVycm9ycw0KPiA+IGZvciBib3RoIHNtYWxs
ZXIgYW5kIGxhcmdlciBwYWdlIHNpemUgbWF0Y2hlcy4gU28gaXQgbWF5IG5vdCBtYXR0ZXIgaWYg
dGhlcmUNCj4gPiBpcw0KPiA+IGEgcmFyZSB1c2FnZSBvciBub3QuIElmIEtWTSBmaW5kcyB0aGUg
Z3Vlc3Qgb3B0cy1pbiAoaG93IHRvIGRvIHRoYXQgVEJEKSwgaXQNCj4gPiBjYW4NCj4gPiBzdGFy
dCBtYXBwaW5nIGF0IHRoZSBob3N0IGxldmVsLiANCj4gDQo+IEhtbSwgY2xldmVyLsKgIFRoYXQg
c2hvdWxkIHdvcms7IHJlcXVpcmluZyBhbiB1cGRhdGVkIGd1ZXN0IGtlcm5lbCB0byBnZXQNCj4g
b3B0aW1hbA0KPiBwZXJmb3JtYW5jZSBkb2Vzbid0IHNlZW0gdG9vIG9uZXJvdXMuDQo+IA0KPiA+
IElmIEtWTSBkb2Vzbid0IHNlZSB0aGUgb3B0LWluLCB0aGUgZ3Vlc3QgZ2V0cyA0ayBwYWdlcy4N
Cj4gDQo+IEFzIGluLCBLVk0gZG9lc24ndCBldmVuIHRyeSB0byB1c2UgaHVnZXBhZ2UgbWFwcGlu
Z3M/wqAgSWYgc28sIHRoaXMgaWRlYQ0KPiBwcm9iYWJseQ0KPiBnZXRzIG15IHZvdGUuDQoNCk1h
eWJlIGFuICJJIGNhbiBoYW5kbGUgaXQiIGFjY2VwdCBzaXplIGJpdCB0aGF0IGNvbWVzIGluIHRo
ZSBleGl0IHF1YWxpZmljYXRpb24/DQoNCllhbiwgZG8geW91IHNlZSBhbnkgcHJvYmxlbXMgd2l0
aCB0aGF0PyBMaWtlIGlmIGEgZ3Vlc3QgcGFzc2VkIGl0IGluIHNvbWUgYWNjZXB0DQphbmQgbm90
IG90aGVycz8gVGhpbmtpbmcgYWJvdXQgdGhlIG5ldyAidW5hY2NlcHQiIFNFQU1DQUxMLi4uDQo=

