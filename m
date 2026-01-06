Return-Path: <kvm+bounces-67099-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 93A16CF6EC0
	for <lists+kvm@lfdr.de>; Tue, 06 Jan 2026 07:48:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A3B95301EF85
	for <lists+kvm@lfdr.de>; Tue,  6 Jan 2026 06:48:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7665308F03;
	Tue,  6 Jan 2026 06:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YSvCy2tF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46CD91E487;
	Tue,  6 Jan 2026 06:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767682095; cv=fail; b=Zm5Y2jSeXS2hdQc4umKaasWCJfInWkbJ1DkcuIMg+Uvs4QHl0Xyj4VxFdHj0ETm1ee27n8mZXT3hgl30a2qVjd8E9ykAaCXgFPbBedOCQdpL3vKgszyJnbiHUhsX8Xy/+IfOMERHyxCPV84HYoRwYXyr+BIBu2KYtayE033BRhM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767682095; c=relaxed/simple;
	bh=UCTP34AvmOYbGnu0ewTltA1yTncySzT6Q4fJclMrmws=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=VkPcjXLlwQxvVA3WUeCVqtuY2e1HGIu4pA/h9ITiusPCFe8405yL8r2ugNp3cVoNHAB7VAm1q8WvJx9wUApeJvh7/0suOiWGz750+BSjSf/qyviA30WogNrd8EOWt0FL7kmR5m5hf/Ao7xRL09k0rY9Wmb8rsbGZPJJp8tk3O14=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YSvCy2tF; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767682094; x=1799218094;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=UCTP34AvmOYbGnu0ewTltA1yTncySzT6Q4fJclMrmws=;
  b=YSvCy2tFeHxlbUyTgfCJYOaOfAmOGf0+jzXWnxlaY2C0zBJAocda8Xs5
   3z1CcNLAgBvvsWA13U+IWte2QWwmCWlR+AxScuKQjPV0lvNcbE37VfCKA
   B7cRD1bmCcV0UGc42sSrgxZg4lygkce3Bfvrxj5ij+OgfrHBHTAJ+lCLG
   yS1Z/BDyW3aY2dNZThtk1RYCwOU5cpjfKbVF7HG1ZyS/U5cOdNmeWunI2
   vzEEUIkUFSSYccdxL5oxIDm/ZmJ7upTjyldoNsHpE7lA2eTdXbpUj6msm
   kFUfVC9DMRjU2zFt6rzyo+/rXpjkfI2c85YXhjZh51LnPNjfx4uHjiTFP
   w==;
X-CSE-ConnectionGUID: u9vd/EfRR9C77e3WkDPtyA==
X-CSE-MsgGUID: frQYGrbkRHi5jXCSLl9zEg==
X-IronPort-AV: E=McAfee;i="6800,10657,11662"; a="72905514"
X-IronPort-AV: E=Sophos;i="6.21,204,1763452800"; 
   d="scan'208";a="72905514"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2026 22:48:14 -0800
X-CSE-ConnectionGUID: rB4Jt09FTbaOQS6Uvmfypg==
X-CSE-MsgGUID: ydGdfRcBRYq0C6fI8rK1xQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,204,1763452800"; 
   d="scan'208";a="226133354"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2026 22:48:13 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 5 Jan 2026 22:48:12 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Mon, 5 Jan 2026 22:48:12 -0800
Received: from PH0PR06CU001.outbound.protection.outlook.com (40.107.208.30) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 5 Jan 2026 22:48:12 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=L7XPadMmAdYCZWVnGaw9bEa4XhD1oKHqri2BZh6zEZc001a5HQ/8CCO8fGpEbxw3KZTMibPkJgdZ5aCxoyIn5A1UFLbXKHIL2altm/xK4hTk2RcF+thSt2OXz1Whl5O4mDPHfxJmgTFf6ZAoRztuAAjNl+oksSDQ5XxRAPWwhve2Ax5IV0bcTv+0GGFGsv23/x2hf6PJhahtLPgR+6hJvcjVwNJ2AoAW3GYWIh42m5wkiLHkPpwbjl91ZOgTY9MSQ+TtXOPJNtGZzE73RvaYwz78qkeEnRdYuXOi+h/mj9PZ9GblYmzzNYH6KXXcUFPJIpSXnRJYWENePl1vycDliA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iZVM7fvdkSToOM5GyTVbLZqFGkXpgJBqsvbf6jewyV8=;
 b=ZE82n2GYSOERFlp8DFwUwI/yFxlGC7HwKGeYptAq5tH1XQxTR4RBlrpq3JserS5gMD5RV1lexNepKjM1Vx8FTfPgJ/Q34znwpsdkzk4YLxUeuGZvZ0O3VIxQnJQEgTyTzttu7JSnI5RgcHDECZFaeE2lSyBzBUgAwWds8Hyu5lXaP7jbilovU7+obvJNByxv/0HCLjoHubofR+B5ZwRC3Of3NRNDPb+TCRB0Y2n1iyOf27MQnIKj6ozxNnvOkF9gLkgxJhEEZQ/pGWFLprf0ustC6g3O1tIsVGynWQAUW0rnblb6eOCrX24a8tZSS2QEgpOSnHe6KBf1xtQFuw+biA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by DS4PPFEDAA4523C.namprd11.prod.outlook.com (2603:10b6:f:fc02::5f) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.1; Tue, 6 Jan
 2026 06:48:09 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf%6]) with mapi id 15.20.9478.004; Tue, 6 Jan 2026
 06:48:09 +0000
Date: Tue, 6 Jan 2026 14:47:57 +0800
From: Chao Gao <chao.gao@intel.com>
To: Kiryl Shutsemau <kas@kernel.org>
CC: <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <x86@kernel.org>, <vishal.l.verma@intel.com>,
	<kai.huang@intel.com>, <dan.j.williams@intel.com>,
	<yilun.xu@linux.intel.com>, <vannapurve@google.com>, Borislav Petkov
	<bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin"
	<hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Rick Edgecombe
	<rick.p.edgecombe@intel.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v2 0/3] Expose TDX Module version
Message-ID: <aVywHbHlcRw2tM/X@intel.com>
References: <20260105074350.98564-1-chao.gao@intel.com>
 <dfb66mcbxqw2a6qjyg74jqp7aucmnkztl224rj3u6znrcr7ukw@yy65kqagdsoh>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <dfb66mcbxqw2a6qjyg74jqp7aucmnkztl224rj3u6znrcr7ukw@yy65kqagdsoh>
X-ClientProxiedBy: SI2P153CA0020.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:190::19) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|DS4PPFEDAA4523C:EE_
X-MS-Office365-Filtering-Correlation-Id: 5522e762-1e8f-420f-619c-08de4cef8daa
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?r63hTIvnbCw0mmcA+KDoMzQsyw07YpY6RwXfLgsj0fGgYlXukixYKJZUEsxq?=
 =?us-ascii?Q?iam2zIdIib+LVnfBEWQ3yFmKtIGyk/WMv1prhU2g3fcKTUi1zQD3u86o74j+?=
 =?us-ascii?Q?niq4oF0CDkENZJVx1KSwni+rxUuJM4LPJpwSmwt4/wK4crJN6V0hDy7UEMUw?=
 =?us-ascii?Q?PrdYYeJn0cJDOIzrMZh+7nrebqiu5nO96ZDfsrU59S5O8w9o5mst3duZmBYz?=
 =?us-ascii?Q?wQbRkcSsmsSHb661Fc7HDyuKk01kBHFuNDqKCLpVTBNwx5QNhsvbWWLGvEHs?=
 =?us-ascii?Q?EyVBPjgtg0iS+wCoZ2nTADBBNfDDN2nlcLd1phh5hhy5w1s+s0fPcJm6x16J?=
 =?us-ascii?Q?6wSBYcZfLhE53BcTwY3soYMDVc+6hfqqAVdIS2NqfN8T5t8pOGatrmZEYlIm?=
 =?us-ascii?Q?YwycexCZaV+UpH4Be651c5GGolUUef5XTzxWJQzNJyWVXTT8t4jt0GjHxi4R?=
 =?us-ascii?Q?cTwsKLYot9sBqwmzq56xospe2vJ+6t16m48c8R6CLIYGEuPwC7vAplWeIq7c?=
 =?us-ascii?Q?Ox4fTTWDTqKrhp6pwLCt4qVHXfaS3O8ujmBjnqvYI83FWp08FePQVQ6ljBPQ?=
 =?us-ascii?Q?W2lyZc/ixiyX6PFz2faR0tdtWm2FpdKbs7gawo3ouztvzqmRb0DRnoqmVk8s?=
 =?us-ascii?Q?svNxVfUCndPX2/75ViUx+CKG2dprG1VkEtA6VJYqDFCqwhb1MpYKCUN48fgo?=
 =?us-ascii?Q?PynJxzC9VnR6y9k3c7Oafesj/iJoXHWJqoQ1IYD9nUTDr7+FCuWwDJaFDviz?=
 =?us-ascii?Q?qJcPrL1NmFux37cXbnSM3oBPFpmp2054pmeAKH7rzxSkhim50neL+Dy/Fs9Z?=
 =?us-ascii?Q?1c88t+BwpHwR0zT/kHvZlSEuwqxQA/oAIK4SxDduh+k9seCOdqZ20IYL2gvk?=
 =?us-ascii?Q?V/VGJkLGGsUM0VGButsaaGOE1JGOC9WqzILPzJSztXnTLZYep/26RUH61F+/?=
 =?us-ascii?Q?R1WeomYcNaOtjZs9gJdOuZE7ogY0lLMn3JlhP9Fl8/R+B/qjjsjbPyEogh3W?=
 =?us-ascii?Q?YK0IPLR/6hSGv5+j8HYe5l4/MQZeK7AbAnvnqoeiagbWQ8L86eBNuvidYNqH?=
 =?us-ascii?Q?1hgac7ol7RfYCP85IJwWRORC4hhfM9nbrQGaOWcZpkd5Qu40YBbCFhhYHu95?=
 =?us-ascii?Q?+ZawHWGKxKBlyGk6XIE7kjncQaissB4JEzRl6ZjB+mKf1HhnM6Lr7zm4ckep?=
 =?us-ascii?Q?hhLW3Vt9bBmkDxjqUKj/2n1ZStjlqSj90qI19PTBlvG5eWNLKZomytAJSqJC?=
 =?us-ascii?Q?PdUbCN/PCQK/hCm3jtr0MzINeGLWge0AeKONH1wp03AtgcyuM4kN8gBpK+nJ?=
 =?us-ascii?Q?AKplPzfddiNtrPExDEmYvMJcD96lHMmRoXMQ951UF4/8PN+JLj/WSVMf8T19?=
 =?us-ascii?Q?Aj2w+UISNMG/CqPc1TgpS1Kc/a7zTjZxz/pb/WYGoGodbHjJpXNBKysep85D?=
 =?us-ascii?Q?fQO90wBjfDhVUpqgykC7ebqa7w9jwwrz?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vws8nHNsThemuNSSCazD1FgAkqn9wJz/mRNIQHe2jNWlXSfPADGWlZLe4ggA?=
 =?us-ascii?Q?lmzgBhlqrH4LXUgrEQ/4XYECyym9lTHd8KcGIkpiUucUX5cYCwyxb2+O4dMA?=
 =?us-ascii?Q?LhHjBEeQPQ409RXoIV+iuFyiUOe+Cymf0EtdecV/+hziRYoula+yzIWlNTyI?=
 =?us-ascii?Q?9p3WiJyyRUKd80DS3faJeFXQait2xA7oZ6aaahX9kUcsZ7hZyBpHNSciwqIM?=
 =?us-ascii?Q?aVOpEWSleL8kgeYpXlkSKrB8jZjrRY9xAwSzSuIr+AGZeQODoMUpRMBXTeCy?=
 =?us-ascii?Q?33tgzoaGb6XSARAXv5xtOA/+d9hSXc7zMAzDFzrQwh1KkRqHO7ejFLIfLklj?=
 =?us-ascii?Q?VES2IMmqvjOq7i5qaBTHF+VjkO+Zu/Zbn/YbaPj2kv/tvRds2BN3RDTdgxxX?=
 =?us-ascii?Q?zHjOREDBm9TOTdRYIiUI7adiAVQEd1gOjHs5AAIjrO3+en+Zgs3dsmUt7ARr?=
 =?us-ascii?Q?TdY0vvWXUkeFOODiixlumFpFlDD86+FY3iiWfb+tddTKWDj6tY+Z6y7kGGXZ?=
 =?us-ascii?Q?7wo3PmXMzNkoia3tn6jBYJ9GaRgHzfVOKcWy9ZEIsIh5Y69VTvK84jsQGi7N?=
 =?us-ascii?Q?obTlnFIXjuyeN2mCdRaEUA33maHaAYwGlwVBLNZL4+OHmzNTEn7L+g8z7L/d?=
 =?us-ascii?Q?I6h+KNPFfPwXLLobNEvXMam1CW2SWuNtRzFl+XLTQ9NU54l/528zZcic1hJq?=
 =?us-ascii?Q?aDAdeeGoMO5aIKDb18AIvqUn4TH+hAsmqiVaepricIM8w9CMWXjE/vNwasuj?=
 =?us-ascii?Q?xkf7IXLPHYWLpu0QJS073xlcr9gAbAWWAzVC6317VYw9uc19vdMPMtbJy+a6?=
 =?us-ascii?Q?+CWi8KfzA93Ts6aqTxVmgSr2Jnr2KAcJreLdYQdsl0ioOG2OFNHtdQxjAi0K?=
 =?us-ascii?Q?H+gHH3RDS+MuVYnO8rnPtR1usFSxWUwvl6iLu/afYSy+Cd7549dunusFC7ez?=
 =?us-ascii?Q?kYT1WF5i3ARdufJIubu80nkrOhctJfh9jav+hMq0KaRWpNj2ci8o5dQ935xr?=
 =?us-ascii?Q?tpviIjzeGFXXkz2nxXa0Rp/rToj1pp+RyADUJ6lnoKcmrLDcYSoduQUN9gVc?=
 =?us-ascii?Q?UVTnEza02mMOfIPMMBmVP3FJKOlT/GsOLdmjjKtNhB3VHHKRzOUCmMDjlxxe?=
 =?us-ascii?Q?3kEmNpjhW+hAGCe0VmI1EJGA2Fqv8yBbizj0XtNesM8j7NksiAsP9XNEwAaL?=
 =?us-ascii?Q?3uTxUTo9K0/Q4T6UWTNCjLSxnqkLJGHFXwGz9TBdqXiKUBlT2hOZiSKozzgG?=
 =?us-ascii?Q?+/PDkl1MwKb/KoAjEc1cRpZxZpU1YeLycrPRw4yHso9F0M9CzQVbfxhW2yQB?=
 =?us-ascii?Q?GHJgZRu9t1FjXiPjBPQRynOA6TT+5ZwTOm0hgv+TeyziAxshpI529yHrKCph?=
 =?us-ascii?Q?uBhWVi+6j2j571+UGTOK167fYBkqycDuDtTQsWWUfFp/ut3/5yxr/r0XLCZ+?=
 =?us-ascii?Q?iMv9z4S05lXJGpGtJUpju+hhTo/TfSyfigBuVokeuxBfzlYMTATWYAGyNVnj?=
 =?us-ascii?Q?or9P4Z5XTCd/bIrmQgZUygVdcFxgACPUEW62iYG8578NoR6Bk3I+Y4sp1ve6?=
 =?us-ascii?Q?xIWsoAqOQWBSrC0kCjl8Ow2Wz0NRAjg7z1vRQgAjoT8lA+YjEFZcK1Xy4nfr?=
 =?us-ascii?Q?T0ebHhrGitTCRzIzY6QrvNGRF8gGV6hMjGWUqjLBqZSATnzL09P+TGrvmyfl?=
 =?us-ascii?Q?NMKsL5yOoyGBLNxv4TbZ3UtzWAoMWZzUyoL0QjmNW60PeGIN2mLgZ4vs2EzZ?=
 =?us-ascii?Q?YE1VYCUlBA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5522e762-1e8f-420f-619c-08de4cef8daa
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2026 06:48:09.2185
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QTCqVxNv9JlweV5zq+K3b56o5z4xHI028EPyWvPpjAZK3HnejyHi5eEPHTA447/h9LusJBZ593Bp3ON1N5Nbuw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPFEDAA4523C
X-OriginatorOrg: intel.com

On Mon, Jan 05, 2026 at 10:38:19AM +0000, Kiryl Shutsemau wrote:
>On Sun, Jan 04, 2026 at 11:43:43PM -0800, Chao Gao wrote:
>> Hi reviewers,
>> 
>> This series is quite straightforward and I believe it's well-polished.
>> Please consider providing your ack tags. However, since it depends on
>> two other series (listed below), please review those dependencies first if
>> you haven't already.
>> 
>> Changes in v2:
>>  - Print TDX Module version in demsg (Vishal)
>>  - Remove all descriptions about autogeneration (Rick)
>>  - Fix typos (Kai)
>>  - Stick with TDH.SYS.RD (Dave/Yilun)
>>  - Rebase onto Sean's VMXON v2 series
>> 
>> === Problem & Solution === 
>> 
>> Currently, there is no user interface to get the TDX Module version.
>> However, in bug reporting or analysis scenarios, the first question
>> normally asked is which TDX Module version is on your system, to determine
>> if this is a known issue or a new regression.
>> 
>> To address this issue, this series exposes the TDX Module version as
>> sysfs attributes of the tdx_host device [*] and also prints it in dmesg
>> to keep a record.
>
>The version information is also useful for the guest. Maybe we should
>provide consistent interface for both sides?

Note that only the Major and Minor versions (like 1.5 or 2.0) are available to
the guest; the TDX Module doesn't allow guests to read the update version.
Given this limitation, exposing version information to guests isn't
particularly useful.

And in my opinion, exposing version information to guests is also unnecessary
since the module version can already be read from the host with this series.
In debugging scenarios, I'm not sure why the TDX module would be so special
that guests should know its version but not other host information, such as
host kernel version, microcode version, etc. None of these are exposed to guest
kernel (not to mention guest userspace).

