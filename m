Return-Path: <kvm+bounces-62826-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 6EA89C502BD
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 02:08:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 8CA604E793A
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 01:06:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7079F221555;
	Wed, 12 Nov 2025 01:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="C5X+P/h3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D6CBC2E0;
	Wed, 12 Nov 2025 01:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762909579; cv=fail; b=FHe0nSamO5Xnikv7pHkuaFsbjZxzoqWBEYVaTwyn04q9tgThd1AOEwzz6X5F9jD0lvL5ihHCEk2dQB3YeFA8OI+pdhdDItnQ4PzlFNz6GenGv4SFnmD8osB1q4bSHk6ej/uhUCtIpfuUOcFEQwkg6/yEJNW838zQKUObVvivkFg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762909579; c=relaxed/simple;
	bh=1rBmfbJskRt1KCvzyFy2SAfEeB2H1X4nOdNGDWHY3DM=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=UHRWKCL5A6mHhtQvq3j/yeJ6YesHY3xZbWPT8aQYwBK3USEMxY/c4vNyLuxJt8r0T6k6KlmNBGwk+B6Ra/N3zT6Jo7EmhQKtS79JjLZ13VigAi2qTCXpqLnPa7Tft5t65SXUWVNkSp99slmI3J1jKluACdd5gKYNpX6scWCWPag=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=C5X+P/h3; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762909578; x=1794445578;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=1rBmfbJskRt1KCvzyFy2SAfEeB2H1X4nOdNGDWHY3DM=;
  b=C5X+P/h3aVoJBfnlDkJ3i5KKU3fjv4AFMIKrDtgNf4fSWANo9if05R7p
   +Nhto0XPmQfJf0PVN5OlI3fdqFOx0rluvuHTFtrdfg7rRVNPeZuZMsQiY
   QOSARoQiUmVVgyqH+90e1orgsnjkqnulh8cXnFVL4yIFObo+3Zd1nBIS1
   +mLV1yu7SvIASs73Tv7gN7xC6wUJTflfWwVU6RWlA4gYBOwday8J3XSeP
   oMBsEzUIUviN3McgqPpeLw9YVelRnu3tCVoyTj3v7xgLu7z1zgQjLMwEh
   bzet7JOT50AnzfF/CQENoldUkXjyqvkAUmzweSWYFKdJN/eQ4wmDxtoPR
   A==;
X-CSE-ConnectionGUID: c2jHCUwcQWyOSF1jW0SnOw==
X-CSE-MsgGUID: x6SPOXNSTdCr+jurvUo9rA==
X-IronPort-AV: E=McAfee;i="6800,10657,11610"; a="75272982"
X-IronPort-AV: E=Sophos;i="6.19,298,1754982000"; 
   d="scan'208";a="75272982"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2025 17:06:17 -0800
X-CSE-ConnectionGUID: ljQNvmm9Q8mUzmmCf/cLoQ==
X-CSE-MsgGUID: +XKootTCQfiHd2U/6Mr92A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,298,1754982000"; 
   d="scan'208";a="188383751"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2025 17:06:16 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 11 Nov 2025 17:06:16 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 11 Nov 2025 17:06:16 -0800
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.12)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 11 Nov 2025 17:06:16 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ytevyVR63BHMIM0bu4J8H6hWuqssZb9D1RsoRKJn2+04FzxY0gNnrpwqd44uvKzUCdo5wUmrwyv8cGSD5HJilRRDuuN7yLo6v+v0EF5QIBJDdr7NisxFclQPTUkwuj+vPVly/bOYLp6SzvULGuQemz+x3p6yovpjXzTqQXNQ1VWHrhBqyAi02mAj2t2aqgXyKxoBUFq/l9NBzw0Hy5XduIE55dtwMdnJoTbtrLJXaNkmCgss07vRu0nuc02ifyrdn404TOxj5ll0l9XlPPwtV+qFira5FfRmtkrJuAiVriN8WCUx2HU5VVJnPclXOgueoMBnnlZJcJDkzeSYswXy5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qN9fe5w+RCa9XO7p7evLCXdHyyz2pyG/qr0yt0NKrKI=;
 b=cpap2QR2ZA0Rn+eX2BxqmcJfcFJwHeoBJcMJALfkKcwB3NCq1Fcl4OcREJIIsOodwckqZI/RyjPOj8cMO6LM6HIFKssxobFzwnb/O5CdtCMEWuqL3EET+/E+R1INlIOBmjqISpfq+gh7LGoYi0lG2y1H6gLMZqj0YdKcgTtQiWlnb6zis2ihIfwx+Lq+8t4ovNS2Gm9MMj+e8KoNEUifkB/vLiFXooi3ctsjMrjLnDsowRQaOiSSo5eTGxXq63Xqqh5qWIoPY2LHGh9y832n7127lzY3GlkRmq4JMOOGbVNc84mdJBe7lrYLdWlZUBGk3NvKW8+nSRTdoZ0lKEF3Mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20) by
 SJ0PR11MB8296.namprd11.prod.outlook.com (2603:10b6:a03:47a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.15; Wed, 12 Nov
 2025 01:06:11 +0000
Received: from DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95]) by DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95%5]) with mapi id 15.20.9320.013; Wed, 12 Nov 2025
 01:06:11 +0000
Message-ID: <f0be7fe5-bdb8-44bc-aa57-7728a72b0b08@intel.com>
Date: Wed, 12 Nov 2025 09:06:05 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: The current status of PKS virtualization
To: Ruihan Li <lrh2000@pku.edu.cn>
CC: Paolo Bonzini <pbonzini@redhat.com>, <lei4.wang@intel.com>, "Sean
 Christopherson" <seanjc@google.com>, Jim Mattson <jmattson@google.com>,
	"Joerg Roedel" <joro@8bytes.org>, kvm <kvm@vger.kernel.org>, "Kernel Mailing
 List, Linux" <linux-kernel@vger.kernel.org>, Vitaly Kuznetsov
	<vkuznets@redhat.com>, Wanpeng Li <wanpengli@tencent.com>
References: <20220424101557.134102-1-lei4.wang@intel.com>
 <20251110162900.354698-1-lrh2000@pku.edu.cn>
 <CABgObfZc4FQa9sj=FK5Q-tQxr2yQ-9Ez69R5z=5_R0x5MS1d0A@mail.gmail.com>
 <dh77d4uo3riuf3d7dbtkbz3k5ubeucnaq4yjdqdbo6uqyplggg@pesxsx2jbkac>
 <2701ea93-48a6-492a-9d4a-17da31d953c2@intel.com>
 <hrfy7h7oob5qimip6midrmuy53vqgbdfgnmwc5avi2zdsd3l36@ts43lrmct5r3>
From: Chenyi Qiang <chenyi.qiang@intel.com>
Content-Language: en-US
In-Reply-To: <hrfy7h7oob5qimip6midrmuy53vqgbdfgnmwc5avi2zdsd3l36@ts43lrmct5r3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TP0P295CA0052.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:910:3::14) To DM3PR11MB8735.namprd11.prod.outlook.com
 (2603:10b6:0:4b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR11MB8735:EE_|SJ0PR11MB8296:EE_
X-MS-Office365-Filtering-Correlation-Id: e8e8b819-ec70-464a-cf3b-08de2187ab61
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?ZkpDY0MxRitRZnFnQnV2VTFYQzZ5QVAvN2FXd3d6UGM1ODZubDM0a2oycmdO?=
 =?utf-8?B?KzJyNGdpZDIvZjM4c0hkT2FGallaZ05QWUh3ZEs2MFRtZEdDZUZuUjg0ZWVq?=
 =?utf-8?B?ZDdraERublFYbFVSWXpsQzRSd0lFOGxkVThDZlV3VFk4Y0N4N3JlVWRqNGpl?=
 =?utf-8?B?OTMvelJVL3VtWS90SW5iQkJGaXBUV3YyUXJ3dDZzVG8wNHhha3ZoQ2J1WlhU?=
 =?utf-8?B?bkNzWWFSdlFMdFpXc1JhTk81RkxUellCaXFhSW91UXd0M1FEQnMwbUlMWUxl?=
 =?utf-8?B?VUlSalZ4SlJyUVkyWnpCaVhyQ05YdzhKUUxrOXBJOSswSkhMTm9ENXNpOE9k?=
 =?utf-8?B?NnV2Z3dYUU0rcFdTZUxXeVNlZG9Ua1RWNVFkbFBXNytJM1NEUVZCUFhCZDhv?=
 =?utf-8?B?TXAzRzBmSVJPVkRZdHBoVGJaWDVwTU1KRzEyd3d5cGsrdFJBSDVEM0Zna3Bq?=
 =?utf-8?B?djcxcnZLdmwvOERTV2tBbndtMEU3cUtXa1NjUlZuUFg1ZmF3ay9lOHRpYlB6?=
 =?utf-8?B?T2NqUHNLS1ozL3QrN1g0cmdGc0gwN01CNUdPTTRIblVwYkM4NThJMXhkMTI1?=
 =?utf-8?B?WXZMWm5rWkh5eXRmKy8rQ3QyZ0xWS1llU2pPcVNHQWllYUlSZktNVlEveGIy?=
 =?utf-8?B?ZDQwNzlOM0JDd0lJOVJKL2dzVEo5eFNsckM3K1VteVBEU3V2dTBkcVphQzJw?=
 =?utf-8?B?T3VaaGdHazY2SW02eUNjL3U0elJ1YjV2SHVsK3ZrZ3VDYjZqakxmSzU1Unpr?=
 =?utf-8?B?ZnhnRlQxZ3YybXptZTRVRnRpVktVZklFYjdaMjZreUk5QktBdUpKazBSYmdx?=
 =?utf-8?B?RVZYenhEOWRGRExiU2VZQWh0NDczRFMvUW8xT0ROODhndnRDeGNLb3V1Nm1S?=
 =?utf-8?B?TGR5aWJUd2pEQVFnaVA4S0tETXlSVGpxekZTNjN3ZUw1QUx0OUJ0MWU1NmFp?=
 =?utf-8?B?WUtUa3RETzM0Z1ZZdDZrbE5OMkM1aWl5Z0huSGNEc1dzeEdxRnhXUzVySW1L?=
 =?utf-8?B?dnFjdGppQ1FzSGZKRWxuWUhFRGVsOHFkZmxBRWNxa3luTmM5Q3puZStUbDVT?=
 =?utf-8?B?Z08zOCtzcHB3R3dPRVJzMy83bG9wbDF1NVg0QllNK0tyckVPYVRTNjlxUVZG?=
 =?utf-8?B?OUJ2c01KVUtHZWNab2U5a3hEOHNWWkxmMWRBWE1kckx6QlkxdktQdTBUaVM3?=
 =?utf-8?B?S3lFakR2dGF2MGNqVEN4MUZwYnY4dHZnRjJLN0NmNHFaVTFEelZzaHVzeGdr?=
 =?utf-8?B?cm13Y21TcGk4cXcwK2c0aCt0d2xvQ0cvKzZZS2QvL3RsUzNqdTAzNkQrZ1RI?=
 =?utf-8?B?Tk1qOWpzTnNZcDR3blUvMXd1ejRxclN0OG05b243dUgwcTZZVlBxNTBqT3pm?=
 =?utf-8?B?MU0zbzE3RzludjJVQkhzSVhvSTdVbTZGQ0s4R3JKUk1jRWNjM3dGODVjTFN2?=
 =?utf-8?B?SDd6WlJpMFhMN1A0SUlyclRIYjlpNXo5MGVLV2hPOFBxY1djcVI1MVY1OXVw?=
 =?utf-8?B?cElIU1RHd0Y1b2NYZ3Y1djZYODh5VVBkd2I3T1ArTlJQK2tBeVNld256Q3hF?=
 =?utf-8?B?ODMyVkdMNXAyYmRFRGxRQytLd0lQK1R5SzRUcXZHL05aYWpaQ1d4OVlETDc3?=
 =?utf-8?B?eG4yUTFXNjdpTTFHZUxuT2RlaS84OE0zUnQ2dDB2WEFyWWRNQ2w1RlM1TzJK?=
 =?utf-8?B?aWxSaG1aQmJIK0JhSXBpOVFXY1owRHpiNERLdmFwMy9EWGI5UEpNY1VFYU9z?=
 =?utf-8?B?TnpEcXJnVnYrL09CK3JJSVoxSnBLOUc0ME5IbHpvZDYrWjJ3eHBaSWNYSzY1?=
 =?utf-8?B?azFOOGZVbEJMOHpIYjNabUw3OXg2MDV3dnQycTBtZWtBa2N1Uy84cExRNW1K?=
 =?utf-8?B?NGRiUHhDZWRsc2dqQ0V0RnJGc1hSRjR0bE9HRHczZ2l3MjFvOVZQMTRHZUdy?=
 =?utf-8?Q?a+W5tmXZ+wHy+JBjIXmRVipQ9lQ6nFyr?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR11MB8735.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bmVhY2cxWHVDWjlJQXBKMVExYzZYQ0Q2YzBpNmY0UEZFNG5wUFM4WnZsVlFQ?=
 =?utf-8?B?V053QXhpblJ5TXd0SGtZS2hvUlgrMllEVENDV0VZSlVncDl5aGFKRGVueWdk?=
 =?utf-8?B?TEFzYUkzV0gzUG43bmhrb3N6MVhGaHh3NGllMjM0RDlhQW9ja0Q5UmlBUHJr?=
 =?utf-8?B?ZEVsSC9hNVZWQlgvT2R4RGsralBmQVRBdXI1NWxUanp3SXNRU3NNUDlLMGtK?=
 =?utf-8?B?THovS01vRXVhUHpFSEhQL2pmTjN5ZXNuWDhHaSswZk1oN3BZL0ZhVERySlZw?=
 =?utf-8?B?eVFub0hGQWd5MCt2VHM4QW5BaURxR2Rrd2dZc1BNU1NkTVBGcTNNRUZKY3U2?=
 =?utf-8?B?SnJaYXNmbXlSY1k4V2Z2MEhaMExKelRQU2JSSnBNaGFtSm5HR1FCajYvbi82?=
 =?utf-8?B?NXk2ZjZpenY5bFJ6TFlXaUdya3B0N0NCYW9mVmlUbnQ3VndjNEdFWk1zUDNT?=
 =?utf-8?B?c3p5TUNpQkgwb1hMY3BpYUVwQ29NamxlR1BydU9sdm9WRmRDN2tuQkphVHNF?=
 =?utf-8?B?Sks1YzlyeHNRQnlmNUZyaVhsdlZLZ2xSSUw3bEZ5TUkvZG96QTk2MHJrNmpz?=
 =?utf-8?B?V29jODRFMDJhcS9VVFVZNjkwY3BPeEhDWHhaTUZPTCtvK25DTS90ZUh0NmRw?=
 =?utf-8?B?blBlN3VjZ0FVSUlCRDRySDh0RTJIMjZtQldadG94UTZPT201blBuOUNKQ1VV?=
 =?utf-8?B?Vk1PU0RRVUlEOVkzb2l3Q0lyY0hURzBHZDdhQmNIdFdJS3JMbUhmWS9oRXox?=
 =?utf-8?B?d2ozVFE1T29HUG9ESGJqTE1sK2tBcmcxV2hxZGdQQTNWRW1HSUhmQk8wQ1hl?=
 =?utf-8?B?S0xVbWdQTkRTTnFiU0g3aUhrMTZYMHFYVVhhR0Y1WWthcUpCNm1XckZkWERw?=
 =?utf-8?B?YVN1eHlHMjlaQzJJVXVOalJwZHFzeE5ObjdyTWEraEZKWTdmZUpUL2dRT3hG?=
 =?utf-8?B?MEkva3FYNWxtQ1huczIwbHVPV1pxc2RlcEd5VVduT1FiSUZnRklxblIyUXZI?=
 =?utf-8?B?Qmp4MVJwSTNyQzlGR1hlU1UrYWFtWmpncEExcTlvdW5lcVdxYVgvcW15aXAw?=
 =?utf-8?B?ejJJZ2w1Q0RHZUNaZEVlOEEvMU4rOGZoSzdLV1ZkdU9IVy9pY0pIL3hLRmZP?=
 =?utf-8?B?NXRld1J1c2VTYWhRTnIxSWdXeHc0bjl3Zy93Snd4ZDkwYVlPZnQ1Ylc2NlBl?=
 =?utf-8?B?R2JBNnVnMjcxUE4wbEZ4Z2xlelRGbUtMSUVpRTlwamVJZkNhdU5EcU5mTEpK?=
 =?utf-8?B?T3RvNXg1L3FpTENxRnB2VlRtT0ZvenFxSnR6R0NqbGpOTmNmd2FFc3ozYStt?=
 =?utf-8?B?ak05OWZwZlE1VjRmSzhvZEhtV202cXdqK0hCa29kSGR2a25hL015L1NXSVp6?=
 =?utf-8?B?eWJQU2JTSFZDb1BLeFkxS2Q4aU9PS2RKSHQ2dkoxSytHNDdFNEEwS041QzY1?=
 =?utf-8?B?MkRaV0lvWE5WeHRPWmhyMXhFbnA3bHZ3MVpsZ3ZCOGlhdGdYV2haSFl1WkRZ?=
 =?utf-8?B?RkowbG1FUUxWdjgzWVN1V3c3cWt4K2dVRkZGTVRMT1huYjhVYjRRejVXSDFp?=
 =?utf-8?B?SHhUOVZjL29uRzFwdzJwUkdHdk4xa0x0WEpYTzRvQWdMajgrTDYyY0lLQjNJ?=
 =?utf-8?B?K0FZYW12MnpjMXRRUW5CSVpaVUFKRWxQS092czdDYkI0QXNIYmE5T25odGVq?=
 =?utf-8?B?aFN2YUVlWkMzNHFCbURQb011TkYxdjU3MkwrOVNSVCt0a2dyQ21INEV0OFl2?=
 =?utf-8?B?WjB4ekV5MmFXSmFRWmd1dktyREhpZ21mNUtyUDJKMTR0QWFOTTVyL0pYZVlY?=
 =?utf-8?B?dWN1c3dNaTA1RUJXZm9BRDRPMldpSzFPRk1XeDVpeGc0VnhtSzVydDNTK2w5?=
 =?utf-8?B?NTVBZHg5WThNWEN1VzI5ZnZlbUZYeUdyMktUZTQrSXJ0VzdLNXI5MGFyb2l1?=
 =?utf-8?B?Q1NuL1k4ZjdpQ3QwYzB3aEZPYXQ0YXROYitmSlM1aVVKNkN0WnFGWGg0Zm5F?=
 =?utf-8?B?S25xeWh2cVo4NXFNOW5YcHd4dHp5aDNGRkg5cTRFSGl1a1N0aCt0eUJlNk5k?=
 =?utf-8?B?TTZjN1g1YW5yZUZKSG5obXpzUzNmdTkrQ2JlWU40U2FDMnlFa1FudlVXMElC?=
 =?utf-8?B?WEdiRnp3a2s3YjZ3R0cxYjZvaUNXNW1KQUMzUE5HL21rMUhGUlQ1L3JkeFR1?=
 =?utf-8?B?L1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e8e8b819-ec70-464a-cf3b-08de2187ab61
X-MS-Exchange-CrossTenant-AuthSource: DM3PR11MB8735.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2025 01:06:11.5689
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yN2jBYqcpNHK/XCdsTvvXYmMwzFumevELubundVW4s/yxUHUFXi6QYQ3SXntRjij6mVbdrOs5h55hK1DmPO6YQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB8296
X-OriginatorOrg: intel.com



On 11/11/2025 10:24 PM, Ruihan Li wrote:
> On Tue, Nov 11, 2025 at 01:40:08PM +0800, Chenyi Qiang wrote:
>> Lei has left Intel so the mail address in unreachable.
>>
>> And as you found, we dropped the PKS KVM upstream along with the base PKS support
>> due to no valid use case in Linux. You can feel free to continue the upstream work.
> 
> Thanks for the reply and for the information!
> 
> By the way, I'm just curious (feel free to ignore this question): Is
> there an on-list discussion that rejects the originally proposed PKS use
> cases?
> 
> I found that pmem stray write protection was rejected [1], but there is
> no reason given nor any reference provided. After searching the list, I
> found the latest patch series that attempts to add pmem stray protection
> [2]. However, I didn't find any discussion rejecting the use case. Maybe
> the discussion happened off the list? Or did I miss something?

The discussion happened off the list. The customer demand for this feature
declined to such an extent that it was not worth working on any longer.

