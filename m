Return-Path: <kvm+bounces-41228-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 19D44A65162
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 14:38:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DB5731899760
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 13:37:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B6E123F434;
	Mon, 17 Mar 2025 13:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bQ5MGFsA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 777A023F401
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 13:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742218618; cv=fail; b=uqOsLoblaCr3LEXekU4NyN3qHTp07XqPkBnC5r3rN2dOTGUr6hPCCimigs7bEQccvLcb/sP+xFBlVUe/d4Lg5AaJ1ScJ0Dw3KoMw1RKFSDSrgCkzPSQKB7GrhVPX8rvIAN+WN7Bbf4bDkmMldMuIkSXmRxRH6GmRlOddvt6T0Uo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742218618; c=relaxed/simple;
	bh=meF8QaP+UlZKYiam4s+JZ+vuOmlr4ROuzVYbKRFDLKk=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=jCUw6XKTWeeFpQUX+0l98jMyc4IB5odwMp+LEb84DVLUQ+gescONd/a8VxZBKRlGHDIHQ+ng4RifB+tzErgGc3r25hX0g/KqyHIveMjvk+i/DW+VUTpy9nx1VO3iagiscoGaosffI+tlQj0Vr+WeXgYy6pTOWMK7Hinx4AfweMg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bQ5MGFsA; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1742218617; x=1773754617;
  h=date:from:to:cc:subject:message-id:
   content-transfer-encoding:mime-version;
  bh=meF8QaP+UlZKYiam4s+JZ+vuOmlr4ROuzVYbKRFDLKk=;
  b=bQ5MGFsAg5VHCwBS9ZyG6oHumykhQiseI+YyZQHBtESlI5HJ+5bTNT5U
   wB+6RXADYSACrDEVfKZ70BhFz+C6Oy93gTNfyyaNxZGyVv47RFIQPR1Pd
   ea+pyzLukuSiEAUx6KdYqQdfB6DnGV1MZknADZ0B2BplXMlMLuJO0bfWx
   7FDM+yqP6lZQusrWIWscMzh1sDVkB/K3pievDI4sQpAT/LQmK97gS6EpT
   7CA4uJoIEd4xxu1A/tFikAWadZ9J0E3i4fbop3weDLi2NWHstlQkuF1F4
   ISyeTxfhhLiuw5M7BdT39kQBvzbueIlAyIwWETWiy5I0Y4ky25E+9axvq
   A==;
X-CSE-ConnectionGUID: cb9UFjOjTa2zIgd+OKN+ew==
X-CSE-MsgGUID: nn5mFYmSQ6iAIij6fKyVuw==
X-IronPort-AV: E=McAfee;i="6700,10204,11376"; a="68669982"
X-IronPort-AV: E=Sophos;i="6.14,254,1736841600"; 
   d="scan'208";a="68669982"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2025 06:36:48 -0700
X-CSE-ConnectionGUID: 3sy1H9a5QpW/Vx6qiFKUDA==
X-CSE-MsgGUID: gc2uEQgHRj2iCB/lPRqiCA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,254,1736841600"; 
   d="scan'208";a="121931036"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2025 06:36:48 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 17 Mar 2025 06:36:47 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Mon, 17 Mar 2025 06:36:47 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.49) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 17 Mar 2025 06:36:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Mt74IS6573xeZXzwznyvZLwOV8YCo6i4Hmoexry5IwgDQ/08ZvBQ9UF8I3iEeMpNPcUVco+BzlN2prruWh9MBxNrJ8kJBOyCM6zXijjMdh61BnzzVmPzxsWU63ry+srGUvC7suTV+4HWvBSBbIv5A+fdpwgRWgeu6bPjW9VCX9fp35c5y/O2MOpFEbCu5nPtO9DUk4f9yzljI1jMGZXb6HK1D4+5O/NQeBpJ5I/tS0bzfto4WQHiEBGVJv+490Y3xHFryTqP2t/xMMM0vkTUjLX/mUDusz+5EsR8MwStOECFKNjUCfOhkiVJT/SAKnEuOoi76bz6+zlxAJWjNlIQPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PWNk4QjtBuX0CZ7usbqzaEO6Hl0aTXO0JIPygLP7jH0=;
 b=bzGfJmGnHwzHX4K7pjUTQ9l8pU12uHd+zhOcwK/7f1NsT5oIrN0WaEfvO1KqnXnVV2eNpoMLnVKaxDlOJ+OWYtmbGfz/E5vpNVFeJa5KbJVDxXJ78+Ejd6Qtsl8KCa7UjcH/TI7gqiyzVK+6AOYi+hwKES8iISwTrcCLnE+WbLXrEkEdEJDZozircM8VOFC5iwYTRvDrCLOdjsB4r6HclaDGqo1tEluceIFNUDgtuzrIAU4Sn3r02dm85BX/0WBIFGj0raI/ZSOXuRDdihr8GbxsPXyhG2JtZPDjXYLVxi7hBc6OHq+QRPPiUekX1/0nq+MdjSgzwqHxLsuLMDFwPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by PH7PR11MB7500.namprd11.prod.outlook.com (2603:10b6:510:275::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.33; Mon, 17 Mar
 2025 13:36:15 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%4]) with mapi id 15.20.8534.031; Mon, 17 Mar 2025
 13:36:15 +0000
Date: Mon, 17 Mar 2025 21:36:07 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <kvm@vger.kernel.org>,
	<oliver.sang@intel.com>
Subject: [sean-jc:vmx/pir_trampoline] [KVM]  420eba08f1:
 kvm-unit-tests.vmx_apicv_test.fail
Message-ID: <202503171652.3f8b1660-lkp@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: SI2PR01CA0009.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::18) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|PH7PR11MB7500:EE_
X-MS-Office365-Filtering-Correlation-Id: f267c357-d4ad-4166-db06-08dd6558b0d6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?MPUI8xwoCdA8ggZhozt/7Bqp0hj4OWvr0S4JyAD3XuM1r4DMQG188tR4yq2B?=
 =?us-ascii?Q?hteWB8HFkJaUEYyNhOzez4EUhOjRHEp0p4lhcYlZG86YEG+QZrj7s10eI1cX?=
 =?us-ascii?Q?l/aOdOrb8M68X+N+Xwpd2g2qEOCi8Y/nttnhfvuoVMMzIkScxpsiRUzDDj9i?=
 =?us-ascii?Q?1e3K5HbnTxpIsiGqv60Otn40+xs9km3E+cjoQlUNiq1R2jFdiBuUjheyQezy?=
 =?us-ascii?Q?mb5XJNXaKNhJtMNAe195Afr1rqVMLFw+952/l0Hm2aCqxU/TOeo7hP7gtLHw?=
 =?us-ascii?Q?zpzaPzgTVelTWfOYQf/mdWInibPQ+3r/jeWjrJLOmVkRaZKyAmMHL564Lctk?=
 =?us-ascii?Q?aPAHVE5H99466FUE6nP3zmiCi7u6u7j8CL+2fLpa0Gwflm7xtVprCldq2rH2?=
 =?us-ascii?Q?fWSbEbkr0IeNrvv2dvCIKhyVypzGXG5RjiL+CPUnNcxkpb5N6V0MDpK+FcxX?=
 =?us-ascii?Q?GYEmTazRhS7Ub6ICEVUO9RuisREXJbJ3B89/+GDC4pkhTNyv+PA8Ttshvdkt?=
 =?us-ascii?Q?7GZYPQ8WEUkgJbGRUxreRZ7Gd3nO/NQSd1pHU/POQIrUDCRnQbkMCjWjTJrb?=
 =?us-ascii?Q?BzRpzadyELuBptWIhIHXUEh9+BupZy/apAmoDqEh3m38VVy+0Q/4SGMRyiai?=
 =?us-ascii?Q?sO+KrIbanbsfqAg9iNG0yCSCXkKJNMQzmyfHENhn1mnX/rW7soyGAO80IR6x?=
 =?us-ascii?Q?l6TRnMjmu01FE14az68Lb1jkg95PijiwA2mRhtKu+OJfjxNYBMYyNzkrl9Hl?=
 =?us-ascii?Q?T+xx4+mVdeABlsuUkvZ4C/H61cG/uEe3uCrkUccrHzr+yyIDkX6BmQBlQ2Lu?=
 =?us-ascii?Q?8CN3o1l/ekgrj6TsOXjeDwpNOUK1EoL2P8CtUQvcl9wvj+ULwYFbtrXny2C/?=
 =?us-ascii?Q?9mX50nCdx8CIHbtw3THJ68NMnyIciTQI+Sso8bdKj5bUnQH6qrPq9U0x5F2T?=
 =?us-ascii?Q?vPosaNBsU20llij8hQgDPgM/JvK4+agzH6FhCOZ/qxYA5cRdZ6J5yiufrk45?=
 =?us-ascii?Q?SZMABcFSdGlurUmc1US0Sp90JiwulAH8ebxSuhg0DECWGplIXGXaSUS3m9uV?=
 =?us-ascii?Q?7NKK3SH5nKvB/rDwPYs4Z33BA47WR0JCNR33rwxrQ+QlqC/E8ys6zOX3rF02?=
 =?us-ascii?Q?3nXZPy6vt+TqfBa1G5Y8ZGwljHwdbMNK8e3c+1U9CkCvbMtkqzk3kUVC97xp?=
 =?us-ascii?Q?jvZHSm1hfqwFHkXkD2oAxmPPqBenC7eCDUxNfmqcar/hCnxR7bHBsWStkYbi?=
 =?us-ascii?Q?fHwQM8aqxyTc9JvlDH5OlXQmf2kgtFjY2s9YmY20C8/+vAqLyfKwl/7R34gf?=
 =?us-ascii?Q?71umrcV+ia9UtnRE2Ne0UlJAl5AXNVCE4CTfinj4whR/dg=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RxJUcQrZ9X5VP+GoICYUU2+c80QyMK9iCfvI/rDMEpbHq1WQz8p+ATjXwlMQ?=
 =?us-ascii?Q?Py0GfM+SgI4UWlQ0GokeGAGo/Wr6oWiNhvBu2evkbMsUIf1ICAyl1LW/lmEX?=
 =?us-ascii?Q?FKEmnBUOz/sR1Iy1gt1pUhL/H6kh7pkf+V+jiLW4ms0RCWycqqD67Ila8A19?=
 =?us-ascii?Q?gl5Q4G85q1HvJkB7zhpTOkInxsONsRlbTuxA9uoS8vOEu81kiKubBnGfJ3sa?=
 =?us-ascii?Q?F4pkdg0KTvEGQ9mcZF1lJWfacR+mmgKJL5kR0Blp0cUK3RMQcxUlS3Vao+Ex?=
 =?us-ascii?Q?oEzQv/DYyRX6UV2ljGd/X6RWgG9406Sm109f6Tq8vcU0GBHZGhI3aJ1IMT+y?=
 =?us-ascii?Q?8bsHHBJ+GtxEthh2uorlwvZ4R22a0mQohR8WGVTR+7K9cAvFieoKk25tW4ES?=
 =?us-ascii?Q?yxQlW/AGeLsihYSDF2An1r/UvSPR6SEwOCdSqpAnzti4cruZwB23mJnDdG0y?=
 =?us-ascii?Q?fe46gQz3u9lGCigbdNkGlJqCMGf1BfVV9qQTB3vQtZJKq/MkE4IM5L7mAS6p?=
 =?us-ascii?Q?L03e72pkTK5pvR98TRT6jNRle21lnl2DiyUW29ODM+yVit2zKArX+mFJ7VQT?=
 =?us-ascii?Q?xH947Uyqd/jUKAQgb6cgpRJrRLc9hOHGBZhjXzwFqSK0KAHJ3nn3SfOqFb02?=
 =?us-ascii?Q?X5bSOXV5ahcp8uxsQ8sIYXKI+Vu6xKtPB1zDPW1XGZ4rhL3f5TAWUP1Ja+oK?=
 =?us-ascii?Q?WHHBn/qV2tHzvq1rimiwV5wqmRW8+oyu0Y01eUrQ4B1hCzFeSi+BZ9zZGm8B?=
 =?us-ascii?Q?Inb8RNbIcgtrF5z/GEnYarbdmRKdzbOYuBOEeO3ea3kp6s1A78r3Kd6IWEa9?=
 =?us-ascii?Q?QHivXWz1frm1mI021DSKnLWJwLKyaB2ES2suQD7ua6EOIWQ7x62TXG4LBAv2?=
 =?us-ascii?Q?1wivGuR7FLoV0X/S9fmVI+iDlJ4FCiN2VGirdqm+TREaPE3EWsba5BNdKZCq?=
 =?us-ascii?Q?Z3eIIjba7ZkCdJZAvOpSQkqdxbCVOWJK1/GpmwyVa/gCBb7JrZcU73fP1LC4?=
 =?us-ascii?Q?xliScxCih+p45edWN2himxpS2+86OrV2d2XgJM+lpcNvU0KQB6zTSeR1zl2Z?=
 =?us-ascii?Q?ghdOCgkEjJPwT6kUYJN/Wf25EqD6kgX0tKTBCp5S3IkKx5piwobGhgbpxKiH?=
 =?us-ascii?Q?5qtuOO5WHecwDrTaL0esIaZJT/69xVh34pR2YGXlTWzejotji7SGVSqcVjsT?=
 =?us-ascii?Q?1XMHaucfb31GO6LISzo6pWMI0QJphWffXq3Yj0Q62lF2SCARXuhLHFsWob+d?=
 =?us-ascii?Q?u+RLfYfJxramoxAGSkGJItoLl/GMfCEW0zFAEIqu+BJNd4Z9SOpKJ78UX7PN?=
 =?us-ascii?Q?7HpDHYc4axraQaoH95VQILGs8qISp7bar7MpN141U9IUmAVD90YS+mnF7T1e?=
 =?us-ascii?Q?Hp/4PlItzjYhbG/BSs87L6xMvp42BBmYaEak+Q0F/f04LzICNsTg3wDTsDjJ?=
 =?us-ascii?Q?GfYKczpXgYD0vpNwBS8b+flN3JgzllGHPlU0GrhAax92wvl1QkwQx5Pgtfuv?=
 =?us-ascii?Q?BHzzY1hrLozFllZUcergYA8R698iBjL6Ig4lbhHsw7PdKZ2wmNOLIs7XTfZO?=
 =?us-ascii?Q?ef/Nn+BUV30d2k36xs4COEaJ9BPIrcqSxdlMQ4Rp?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f267c357-d4ad-4166-db06-08dd6558b0d6
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2025 13:36:15.6699
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FoRscCF6PX69q7QUOrm8H4dJ7+qeZvFZ0efyaoEY7cMdNhp1EuuXWiRsAueMeOwF1gLpFuYxAh7o2AcNFR/1MQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7500
X-OriginatorOrg: intel.com



Hello,

kernel test robot noticed "kvm-unit-tests.vmx_apicv_test.fail" on:

commit: 420eba08f13475d6e006958a3a376f24151fe3ca ("KVM: VMX: Don't bounce I=
RQs through PIR if they are unlikely to be posted")
https://github.com/sean-jc/linux vmx/pir_trampoline

in testcase: kvm-unit-tests
version: kvm-unit-tests-x86_64-0cc3a351-1_20250307
with following parameters:




config: x86_64-rhel-9.4-func
compiler: gcc-12
test machine: 256 threads 4 sockets INTEL(R) XEON(R) PLATINUM 8592+ (Emeral=
d Rapids) with 256G memory

(please refer to attached dmesg/kmsg for entire log/backtrace)


besides, we also noticed kvm-unit-tests.vmx_apic_passthrough_thread.fail up=
on
420eba08f1 but can pass on parent.

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
tbox_group/testcase/rootfs/kconfig/compiler:
  lkp-emr-2sp1/kvm-unit-tests/debian-12-x86_64-20240206.cgz/x86_64-rhel-9.4=
-func/gcc-12

15fa47622ce7e0d0 420eba08f13475d6e006958a3a3
---------------- ---------------------------
       fail:runs  %reproduction    fail:runs
           |             |             |
           :6          100%           6:6     kvm-unit-tests.vmx_apic_passt=
hrough_thread.fail
           :6          100%           6:6     kvm-unit-tests.vmx_apicv_test=
.fail



If you fix the issue in a separate patch/commit (i.e. not just a new versio=
n of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202503171652.3f8b1660-lkp@intel.co=
m

QEMU emulator version 7.2.15 (Debian 1:7.2+dfsg-7+deb12u12)
Copyright (c) 2003-2022 Fabrice Bellard and the QEMU Project developers
2025-03-13 12:30:20 ./run_tests.sh
=1B[32mPASS=1B[0m apic-split (56 tests)
=1B[32mPASS=1B[0m ioapic-split (19 tests)
=1B[32mPASS=1B[0m x2apic (56 tests)
=1B[32mPASS=1B[0m xapic (45 tests, 1 skipped)
=1B[32mPASS=1B[0m ioapic (26 tests)
=1B[33mSKIP=1B[0m cmpxchg8b (i386 only)
=1B[32mPASS=1B[0m smptest (1 tests)
=1B[32mPASS=1B[0m smptest3 (1 tests)
=1B[32mPASS=1B[0m vmexit_cpuid=20
=1B[32mPASS=1B[0m vmexit_vmcall=20
=1B[32mPASS=1B[0m vmexit_mov_from_cr8=20
=1B[32mPASS=1B[0m vmexit_mov_to_cr8=20
=1B[32mPASS=1B[0m vmexit_inl_pmtimer=20
=1B[32mPASS=1B[0m vmexit_ipi=20
=1B[32mPASS=1B[0m vmexit_ipi_halt=20
=1B[32mPASS=1B[0m vmexit_ple_round_robin=20
=1B[32mPASS=1B[0m vmexit_tscdeadline=20
=1B[32mPASS=1B[0m vmexit_tscdeadline_immed=20
=1B[32mPASS=1B[0m vmexit_cr0_wp=20
=1B[32mPASS=1B[0m vmexit_cr4_pge=20
=1B[32mPASS=1B[0m access (2 tests)
=1B[33mSKIP=1B[0m access_fep (test marked as manual run only)
=1B[32mPASS=1B[0m access-reduced-maxphyaddr (1 tests)
=1B[32mPASS=1B[0m smap (18 tests)
=1B[32mPASS=1B[0m pku (7 tests)
=1B[33mSKIP=1B[0m pks (0 tests)
=1B[32mPASS=1B[0m asyncpf (2 tests, 1 skipped)
=1B[32mPASS=1B[0m emulator (140 tests, 2 skipped)
=1B[32mPASS=1B[0m eventinj (13 tests)
=1B[32mPASS=1B[0m hypercall (2 tests)
=1B[32mPASS=1B[0m idt_test (4 tests)
=1B[32mPASS=1B[0m memory (7 tests, 1 skipped)
=1B[32mPASS=1B[0m msr (1836 tests)
=1B[32mPASS=1B[0m pmu (267 tests, 22 skipped)
=1B[33mSKIP=1B[0m pmu_lbr (1 tests, 1 skipped)
=1B[32mPASS=1B[0m pmu_pebs (36 tests)
=1B[32mPASS=1B[0m vmware_backdoors (11 tests)
=1B[32mPASS=1B[0m realmode=20
=1B[32mPASS=1B[0m s3=20
=1B[32mPASS=1B[0m setjmp (10 tests)
=1B[32mPASS=1B[0m sieve=20
=1B[32mPASS=1B[0m syscall (2 tests)
=1B[32mPASS=1B[0m tsc (6 tests)
=1B[32mPASS=1B[0m tsc_adjust (6 tests)
=1B[32mPASS=1B[0m xsave (17 tests)
=1B[32mPASS=1B[0m rmap_chain=20
=1B[33mSKIP=1B[0m svm (0 tests)
=1B[33mSKIP=1B[0m svm_pause_filter (0 tests)
=1B[33mSKIP=1B[0m svm_npt (0 tests)
=1B[33mSKIP=1B[0m taskswitch (i386 only)
=1B[33mSKIP=1B[0m taskswitch2 (i386 only)
=1B[32mPASS=1B[0m kvmclock_test=20
=1B[32mPASS=1B[0m pcid-enabled (2 tests)
=1B[32mPASS=1B[0m pcid-disabled (2 tests)
=1B[32mPASS=1B[0m pcid-asymmetric (2 tests)
=1B[32mPASS=1B[0m rdpru (1 tests)
=1B[32mPASS=1B[0m umip (21 tests)
=1B[32mPASS=1B[0m la57 (61 tests, 3 skipped)
=1B[31mFAIL=1B[0m vmx (9863 tests, 42 unexpected failures, 6 skipped)
=1B[32mPASS=1B[0m ept (6564 tests)
=1B[32mPASS=1B[0m vmx_eoi_bitmap_ioapic_scan (7 tests)
=1B[32mPASS=1B[0m vmx_hlt_with_rvi_test (7 tests)
=1B[31mFAIL=1B[0m vmx_apicv_test (4955 tests, 3 unexpected failures)    <--=
---
=1B[32mPASS=1B[0m vmx_posted_intr_test (28024 tests)
=1B[31mFAIL=1B[0m vmx_apic_passthrough_thread (5 tests, 1 unexpected failur=
es)    <-----
=1B[32mPASS=1B[0m vmx_init_signal_test (11 tests)
=1B[32mPASS=1B[0m vmx_sipi_signal_test (12 tests)
=1B[32mPASS=1B[0m vmx_apic_passthrough_tpr_threshold_test (6 tests)
=1B[32mPASS=1B[0m vmx_vmcs_shadow_test (153979 tests)
=1B[32mPASS=1B[0m vmx_pf_exception_test (75 tests)
=1B[33mSKIP=1B[0m vmx_pf_exception_test_fep (test marked as manual run only=
)
=1B[33mSKIP=1B[0m vmx_pf_vpid_test (test marked as manual run only)
=1B[33mSKIP=1B[0m vmx_pf_invvpid_test (test marked as manual run only)
=1B[33mSKIP=1B[0m vmx_pf_no_vpid_test (test marked as manual run only)
=1B[32mPASS=1B[0m vmx_pf_exception_test_reduced_maxphyaddr (67 tests)
=1B[32mPASS=1B[0m debug (25 tests)
=1B[32mPASS=1B[0m hyperv_synic (1 tests)
=1B[32mPASS=1B[0m hyperv_connections (7 tests)
=1B[32mPASS=1B[0m hyperv_stimer (12 tests)
=1B[32mPASS=1B[0m hyperv_stimer_direct (8 tests)
=1B[32mPASS=1B[0m hyperv_clock (3 tests)
=1B[32mPASS=1B[0m intel_iommu (11 tests)
=1B[32mPASS=1B[0m tsx-ctrl (7 tests)
=1B[33mSKIP=1B[0m intel_cet (0 tests)
=1B[32mPASS=1B[0m lam (19 tests)



The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20250317/202503171652.3f8b1660-lkp@=
intel.com



--=20
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


