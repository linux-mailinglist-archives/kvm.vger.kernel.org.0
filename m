Return-Path: <kvm+bounces-3424-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id F14AC804369
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 01:30:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4C17CB20B5F
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 00:30:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1986111D;
	Tue,  5 Dec 2023 00:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lE8myy7W"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F26FB0;
	Mon,  4 Dec 2023 16:30:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701736216; x=1733272216;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=cwldwLV9tnlaN1PBZG2sTEKF9j0+F0VNhngFQnxnJx8=;
  b=lE8myy7Wwm60/yU2hWxGv4+m7Kq9xpsfPJOrV1uDPXmRoAZf3OA5nWQN
   LFJiAANWeDO1z8ji8KLscvNsJYCzFxijJ0O3qNAuwGQAj8BDYYN6sTAqu
   Yk8+OQTMMALorXL8oMyTVGRIe7gyY1DhGgdDblQaFGH3ekR5QloH3F4cM
   x70jzGzhgCWzQU+xr7OKDD82H9p0ajtclHnM73Yw1jdjgSaI7xR6P3cOv
   I6xFUPaS52HHPIsth+AWEVNFsFTp3JpOw6h84WL8BcEBy16wnUWjYoCR5
   PwJGNyFfhR/tu27/wJcPLVK9pOY2ZDwY1g7xkjf15nD8Z34sx25m6k1XL
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10914"; a="692112"
X-IronPort-AV: E=Sophos;i="6.04,251,1695711600"; 
   d="scan'208";a="692112"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2023 16:30:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.04,251,1695711600"; 
   d="scan'208";a="18761962"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Dec 2023 16:30:15 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 4 Dec 2023 16:30:14 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 4 Dec 2023 16:30:14 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Mon, 4 Dec 2023 16:30:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HuU75kJy+uL1jaSzmksr/5ox+cAzq01PXcgEJ4uETTYcYRAWvclF4Rp8NgcJHAbiamYvfiDUFPnCAXtHhMvox4QIEVbLns7DwyB6mApTUXbFKqOw1pyRp8L4N5xswmeTvH9LM/BTdgkJF5ndqyYIMcOdNmjEdipzdXApC90cTFF9ZE5oa87zSpvbZTm67K4eAuIxvDnxx9kvAnABMkPpUzAZXqjCto/pbnXi6VtigJSMOOtRJfliu6Kmi+0DpHCxVRVV1tVmSx7gb17Wd9Y+DsphsG5eK602HJXlMjLq7s37020yFbyq+j3rhnC4kSiUTCjXAoq0Bt4Lbc3+sQKhRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+QGhxs2gOpvhXlYHiK8MAloXwnJymUIYW3lb3tlVLHk=;
 b=mA7FlLq7X8EG+w+JFOcQCsevOxiZpasXS2j3issZWlg2KLrFx+tDP0o722rLM8HRG+aS2tKPqD2GuK4dDgkU3ka+u7nIK8eeLf6KPRpCdp+rM1izGY6TwDzbTXjBw+l6cTn4LtZkzGnJIYYYFB3UTRHACStBZwR8HsE58lUsbz2CsVlSIdKTclCz+olQWIkfcXIkY2ayHJWDUM7YcRKRPjoKp+9dM1j4Dnc8TWezSCjX36pK/pBs0JNK6eHKAm5ucYEk89ogh2AUmmegcYPyStwO80ic01r/xJsA9E0N91xxmNO4UPTPleD1KRz9XaYPU1N1dZtXnynBXcRty42rtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by SJ2PR11MB7502.namprd11.prod.outlook.com (2603:10b6:a03:4d3::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.33; Tue, 5 Dec
 2023 00:30:08 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6362:763e:f84b:4169]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6362:763e:f84b:4169%5]) with mapi id 15.20.7046.033; Tue, 5 Dec 2023
 00:30:08 +0000
Date: Mon, 4 Dec 2023 16:30:02 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: Dionna Amalie Glaze <dionnaglaze@google.com>, Sean Christopherson
	<seanjc@google.com>
CC: Michael Roth <michael.roth@amd.com>, Alexey Kardashevskiy <aik@amd.com>,
	<kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-crypto@vger.kernel.org>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <hpa@zytor.com>,
	<ardb@kernel.org>, <pbonzini@redhat.com>, <vkuznets@redhat.com>,
	<jmattson@google.com>, <luto@kernel.org>, <dave.hansen@linux.intel.com>,
	<slp@redhat.com>, <pgonda@google.com>, <peterz@infradead.org>,
	<srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
	<dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>, <vbabka@suse.cz>,
	<kirill@shutemov.name>, <ak@linux.intel.com>, <tony.luck@intel.com>,
	<sathyanarayanan.kuppuswamy@linux.intel.com>, <alpergun@google.com>,
	<jarkko@kernel.org>, <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>,
	Brijesh Singh <brijesh.singh@amd.com>, Dan Williams
	<dan.j.williams@intel.com>, <dan.middleton@intel.com>
Subject: Re: [PATCH v10 48/50] KVM: SEV: Provide support for
 SNP_GUEST_REQUEST NAE event
Message-ID: <656e6f0aa1c5_4568a29451@dwillia2-xfh.jf.intel.com.notmuch>
References: <20231016132819.1002933-1-michael.roth@amd.com>
 <20231016132819.1002933-49-michael.roth@amd.com>
 <CAAH4kHb=hNH88poYw-fj+ewYgt8F-hseZcRuLDdvbgpSQ5FDZQ@mail.gmail.com>
 <ZS614OSoritrE1d2@google.com>
 <b9da2fed-b527-4242-a588-7fc3ee6c9070@amd.com>
 <ZS_iS4UOgBbssp7Z@google.com>
 <20231110220756.7hhiy36jc6jiu7nm@amd.com>
 <ZU6zGgvfhga0Oiob@google.com>
 <CAAH4kHYPAiS+_KKhb1=8q=OkS+XBsES8J3K_acJ_5YcNZPi=kA@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAAH4kHYPAiS+_KKhb1=8q=OkS+XBsES8J3K_acJ_5YcNZPi=kA@mail.gmail.com>
X-ClientProxiedBy: MW4P221CA0020.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:303:8b::25) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|SJ2PR11MB7502:EE_
X-MS-Office365-Filtering-Correlation-Id: dd64637d-5662-493a-9b85-08dbf529552d
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XXjzxHmPhGQrqiAsKjxNMyadBBat9/qH89E/9RFFl9YSJG4Ej2VofhDvIm1Byrimw7VkK5fRJoTuuT2v20a7ltCZOs+UgWQgCwqn2elo2Xm+JGdF2qy0uOMUVSKT0hdp9v7g5Z5j0bBbeIglAKKydSQW4xPWTSzU2dRYE3cfepEyvHqTDdp4+/64Tt+7lNzp4yRS4Z5cviWKWqjA5JsWtzfcsZ/5uDP2dba/wfFr/h8e/3VHcx0ADjVmBzQHpgW3N9lcRE5M7dgVGce0Ga0VQI7xiTXB4vYOzxxayRUqRtjJYw1PVdvFrsn4sM8rPwzpYi+e5K8SqwIf4B0XtruYkvuiaKxDw1EbF1tVYQMOop9WlIqI6kw6YZkCGcWbFad75O99VwGxDurg73BSSIj22/hXHIlQmcD77LbqEEKAjfVrYr1WSck0SNMnFSZ7f24R3C2l7k0yk2/En923GcsPsQ0kJJpQODBdSF+FMcZzOULslA9XZwpzBhw00RlN70VLaUtso+R3P7hC5/9FCu2ypkzN0u9co6KsS8P1hSF9Qik=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(396003)(39860400002)(346002)(376002)(366004)(230922051799003)(451199024)(64100799003)(186009)(1800799012)(7406005)(5660300002)(86362001)(4326008)(8676002)(8936002)(2906002)(7416002)(41300700001)(6512007)(9686003)(6506007)(82960400001)(6666004)(83380400001)(6486002)(966005)(478600001)(26005)(38100700002)(110136005)(316002)(54906003)(66476007)(66556008)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uRG7dOVFQRCLnoT4Fh/KQZnKz9yhNAOsurx3nDqSgvMwYk27aU0zwjZrRH+F?=
 =?us-ascii?Q?qiKOPpqM9g+YVWtquMdLOE500jivC3AoUtrGKVUNIk+sq2pzNWzweeEaTqKm?=
 =?us-ascii?Q?hEaudyafq9nBDUOEnIVvD728Ejnoq7Wuj1jlFJ56yt7RG3pmGMas6IcXpSIa?=
 =?us-ascii?Q?uM8KIIWN7LIk+bL1LmsWkSxLqQnSvgPaXByWyGX2UfqF2YhhnGZuG37zeVDY?=
 =?us-ascii?Q?HPt0d6j0DgkHHxF6prY4yqINj4J3SmsbwdNNczTcYsF0on50PR2Enmdl/ijG?=
 =?us-ascii?Q?Y0a5akBe9uNGgnISYUpMIHwZCaHPUPkofk0FPoKLAUO0+VgCytWt/mRGzNh0?=
 =?us-ascii?Q?/TWWP04RcgivWd+h/USNdYixn6+1Vj7kR4GYn3mAav47NLz7/ZjRpzVRGzYm?=
 =?us-ascii?Q?kGTQMJJCj64pYhkX1V5eHRoerwc8lc2biSM6hSTcWNmRo44wgTENJM5At4A0?=
 =?us-ascii?Q?mIl4uHgEhzyKIiccWOiqkDrmeIf9tDFvMnhyARIk8Qm06dRN58Ne0ymYT4Pa?=
 =?us-ascii?Q?gqOVYG/RWvT9+UauGkARNtkC2TnGCJ3BT9mab1Uu4lhMULZ5L9JzCcMcdro8?=
 =?us-ascii?Q?aFHisW4u691BeDGxZsmvRwyql0f7TBE3yLG+UP0w4TMsTGq0hsi/2V7mGSee?=
 =?us-ascii?Q?vwlYEuSQmcYgSHMzQgPsih05I8JhYOWHqUxSmlrSaBkq4Di0voF4IdDkYuFK?=
 =?us-ascii?Q?nB2Oc53MecDWOQG5aoF/xJy9J7G9wdvhuvGGinJ6iVXE0JvZha0+P/MoA8kS?=
 =?us-ascii?Q?kuGhmoFuKlH4hyiqc2fWnC+2IejqxTCDkbjRFSdcCE8Tn3P9Z0L1nNJZBHJ3?=
 =?us-ascii?Q?uOqi9+FSetjyKHJEZ1lQD7v6/eOU7PsAOhop7yxmq+2da49g7SRWukA7RdhU?=
 =?us-ascii?Q?Iu9qsDYFm6LinVEZX/8u0AX8EjEulz/50rlMbjFdMmnBcse0HFVxjccRxLu9?=
 =?us-ascii?Q?tw+eXB/P3KPMXRxRolS+u0C/jZY4E6U4JqCYEzRak5XLdCxF9GnE4zIyM5sx?=
 =?us-ascii?Q?RL7sq/CusSd8dD0eZEj++fuTUYTLkLmH5DjmfeT0Q0oQ4lXyU1LymVfW4jcd?=
 =?us-ascii?Q?YVchRvTItOZ+kLLovwNfoAkyyb98S5lnxoN0XcTTpJHK0NhP/XgapycZ1mix?=
 =?us-ascii?Q?a7B6wKjTi5YOKju9SmgvXkKoioYNUie6R/uR5tPDKrpdN32/jkj7fxWLgk8c?=
 =?us-ascii?Q?FgXP1qQgAZ1phD2XdquAYcSwKf4BRg1ALjSfdQnLvfgphnt1SVVyIim7z/xf?=
 =?us-ascii?Q?Mg7Oz0Xbb0Pr9IEh2mqq2/VLBQoqcBL7KGQTSMF0Zt/xNcXEgmNxXg3qoosw?=
 =?us-ascii?Q?ENn7uVcxdb1bRslW19ppX/9xM8bwWcnlKXTxRMdOuv3MLx/+w7h272HG6E42?=
 =?us-ascii?Q?7OqAx0VuFPDoScsXg8PmzLwrZowOCNIh0/qjsIQDuyhCtGmyXbIZ/8WG7cPo?=
 =?us-ascii?Q?sGI2jm0HfNTcHP1obpTG3HZzFIaSugMfGJpaFvSkOJFzByLIDxwhZFN37bfG?=
 =?us-ascii?Q?qlQN3QnCekO/E9g+GwWPP2YuJGM+/mHIZb0PwlcosNuFv94Cg7JzdmLBpOJy?=
 =?us-ascii?Q?RDgnm5clsQjJARWAisAAXM2SuQPGUagF0rx4NGCb5eMbR2H62TtZJZT3l9wc?=
 =?us-ascii?Q?wA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: dd64637d-5662-493a-9b85-08dbf529552d
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2023 00:30:08.0675
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WxOBSmNm5OfSCiz272W9kkmQoKF++l7Mzd4plTCap/ZZGhcyYL1j5Qhq9/MR2fc2/nW3K3vxC4BKPrDjHRQt9EB/VA3N+jA8GnVDwRwIQI8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7502
X-OriginatorOrg: intel.com

[ add Dan Middleton for his awareness ]

Dionna Amalie Glaze wrote:
> > > So we're sort of complicating the more common case to support a more niche
> > > one (as far as userspace is concerned anyway; as far as kernel goes, your
> > > approach is certainly simplest :)).
> > >
> > > Instead, maybe a compromise is warranted so the requirements on userspace
> > > side are less complicated for a more basic deployment:
> > >
> > >   1) If /dev/sev is used to set a global certificate, then that will be
> > >      used unconditionally by KVM, protected by simple dumb mutex during
> > >      usage/update.
> > >   2) If /dev/sev is not used to set the global certificate is the value
> > >      is NULL, we assume userspace wants full responsibility for managing
> > >      certificates and exit to userspace to request the certs in the manner
> > >      you suggested.
> > >
> > > Sean, Dionna, would this cover your concerns and address the certificate
> > > update use-case?
> >
> > Honestly, no.  I see zero reason for the kernel to be involved.  IIUC, there's no
> > privileged operations that require kernel intervention, which means that shoving
> > a global cert into /dev/sev is using the CCP driver as middleman.  Just use a
> > userspace daemon.  I have a very hard time believing that passing around large-ish
> > blobs of data in userspace isn't already a solved problem.
> 
> ping sathyanarayanan.kuppuswamy@linux.intel.com and +Dan Williams

Apologies Dionna, I missed this earlier. 

> 
> I think for a uniform experience for all coco technologies, we need
> someone from Intel to weigh in on supporting auxblob through a similar
> vmexit. Whereas the quoting enclave gets its PCK cert installed by the
> host, something like the firmware's SBOM [1] could be delivered in
> auxblob. The proposal to embed the compressed SBOM binary in a coff
> section of the UEFI doesn't get it communicated to user space, so this
> is a good place to get that info about the expected TDMR in. The SBOM
> proposal itself would need additional modeling in the coRIM profile to
> have extra coco-specific measurements or we need to find some other
> method of getting this info bundled with the attestation report.

SBOM looks different than the SEV use case of @auxblob to convey a
certificate chain.

Are you asking for @auxblob to be SBOM on TDX and a certchain on SEV, or
unifying the @auxblob format on SBOM?

> My own plan for SEV-SNP was to have a bespoke signed measurement of
> the UEFI in the GUID table, but that doesn't extend to TDX. If we're
> looking more at an industry alignment on coRIM for SBOM formats (yes
> please), then it'd be great to start getting that kind of info plumbed
> to the user in a uniform way that doesn't have to rely on servers
> providing the endorsements.
> 
> [1] https://uefi.org/blog/firmware-sbom-proposal

Honestly my first reaction for this ABI would be for a new file under
/sys/firmware/efi/efivars or similar.

