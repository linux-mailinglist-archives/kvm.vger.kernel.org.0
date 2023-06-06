Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19505723568
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 04:43:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234220AbjFFCnc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 22:43:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231603AbjFFCna (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 22:43:30 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4269410C
        for <kvm@vger.kernel.org>; Mon,  5 Jun 2023 19:43:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686019409; x=1717555409;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=B2E8Pf8rJlLNbhhCAs9VYoeCjpmxqC61ODz4LX254SA=;
  b=YVxzrHU2W/ZWD+WXG/IrQSYQtG4XsRAoqQK4K0NKA6312QXezppn++DV
   DMfm79C27TsULV+yweiicdR18pFt4xIJXxfteLPuI2SGmhsLGDeMcQVei
   jb2/Z46Ioip9Cj+CzIWGHcgJw6cJYqf01n4l6xpO/Lc82V9chOv+c5BXN
   o/+L5Mvg9KBD2eT1rVRyaq9sLSDDVh1OTaGZs1SGOTv/LC32CH+YxK4bN
   a0zMCqJL6qFnqRvMUZxO9L5/B4/prJr6pSO8K8cszGwbzBcpKxaVCzlgT
   D5Km5vS4wmWsiKDrhA3h6khNBKEU2O/tGp+DV5nzbKZ10Pm3qtygYAgCf
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="336901308"
X-IronPort-AV: E=Sophos;i="6.00,219,1681196400"; 
   d="scan'208";a="336901308"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2023 19:43:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="702986821"
X-IronPort-AV: E=Sophos;i="6.00,219,1681196400"; 
   d="scan'208";a="702986821"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga007.jf.intel.com with ESMTP; 05 Jun 2023 19:43:28 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 5 Jun 2023 19:43:28 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 5 Jun 2023 19:43:28 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 5 Jun 2023 19:43:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cDlbKkN12nVvkFe0IbNG8chvy1bDWe0ejJHOaw75FGyg4g2LTB29Tnv28RwwQsPXwD0Sp8ELxo3R3WtpPZqtevym8M/Isn0OQVFl7l2ZR1sxQ8y4cDSqIKIZlvEDlelc/l7lO/TNKqQHGN7IhCAvwBJUH54Q0PoDjWYchiWOaIxCpUd8KIgJJRd43mYMG39iIdmQM3Udl9rY3fR4oLkGfV37g5Vxd+csZbUlTlPw47QNjiHndCz+RQZhzxXbGtiy+T2GtppYT1TtVFNSJCQnqwtpU36OF95fvlwCMg46AcTxBkMLzsbgY7QS6be0wH/x07Htd9AeU9x0EU5wDJxXuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s5ISiI/a8PMdu2T1iIxN8C4sNxhhU6AF+BsbvjIocwI=;
 b=Z/RBSTdjsZprXezLjJssTg6WKDbAFcv3+kh9tXVk7wdyR8DU25PBWnkYHkD7U7s+NxPpsylq6xNHMFfChzz+iYyHC0G5/jdifTJyUgNyLIFXrrBc8XKmid5C6f3AjSUgZt/TgdrqAhifSqMFnThUbLnPed0bXmVji8paQljO9eoYodSqndDaKdXXXaMxtoxPglYRPs8Cip87CfM+8c6lIOgmOnZ5TVHijj+f4aJPWmNZ0R3QDHpQEYWiJVvhcU5xPIPcH4ttC4j09pKcwdaVlUeoSEruShPCQzkm3b5KOl7TBchBi+vFQjprSClbgt4uox5XqKGH1hDgxJpSFV7eXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by CO1PR11MB4785.namprd11.prod.outlook.com (2603:10b6:303:6f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Tue, 6 Jun
 2023 02:43:27 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::95c6:c77e:733b:eee5]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::95c6:c77e:733b:eee5%5]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 02:43:26 +0000
Date:   Mon, 5 Jun 2023 19:43:23 -0700
From:   Dan Williams <dan.j.williams@intel.com>
To:     "Giani, Dhaval" <Dhaval.Giani@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Kardashevskiy, Alexey" <Alexey.Kardashevskiy@amd.com>,
        "Kaplan, David" <David.Kaplan@amd.com>,
        "steffen.eiden@ibm.com" <steffen.eiden@ibm.com>,
        "yilun.xu@intel.com" <yilun.xu@intel.com>,
        Suzuki K P <suzuki.kp@gmail.com>,
        "Powell, Jeremy" <Jeremy.Powell@amd.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "atishp04@gmail.com" <atishp04@gmail.com>
CC:     "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>, <lukas@wunner.de>
Subject: RE: KVM Forum BoF on I/O + secure virtualization
Message-ID: <647e9d4be14dd_142af8294b2@dwillia2-xfh.jf.intel.com.notmuch>
References: <c2db1a80-722b-c807-76b5-b8672cb0db09@redhat.com>
 <MW4PR12MB7213E05A15C3F45CA6F9E93B8D4EA@MW4PR12MB7213.namprd12.prod.outlook.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <MW4PR12MB7213E05A15C3F45CA6F9E93B8D4EA@MW4PR12MB7213.namprd12.prod.outlook.com>
X-ClientProxiedBy: SJ0PR03CA0237.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::32) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|CO1PR11MB4785:EE_
X-MS-Office365-Filtering-Correlation-Id: 334fe195-f71e-4843-247b-08db6637cd9e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ocb4UQcN+KqnSiYBT0xgvSpJKMpVVD1A54xBorSFhh9qecZ+nw4+20WZ3DkvaSdI1wzqI5Ftqt5IZZcU16qtbkiEZ3WhCkjMoXBHRhugPA9PIR7Xim1DGq5v4kELsNUXUMXkImP84rDZofReDAtH8f2ksr4hBzidmvO23ozxPcEOKiyXMe3qz6z4AAIutiodn3mu+2t8hlzgGqLxVWbVZPtcQS+zjaF8lJMJAUhckCttzncayYTUfVGH97WCznuD9NFG1NMzebGEihSwBbOI3TON4bH33yXb3bkP/8dJT/Z4c1N7uDoGDTVE9eEqS1X8HF6Eb2Dx9JTaG73fSvBwqwvqAR/XcWEOvpQRywLx1aqXOvyXwejYR44Mum/E4pUWC6qNG7nxzpUJ+Rbd8AG72CJtAisJzLr1F6WIeQGFCuhGXWPcY9tNRKh19+W2w6haDgZEOOSfVWR2y7M7b6HCwVPF+CUdTxYr0fhlgXyj6ssCCpsyvM/0nMuCEddeRqkw1HHhkIDqPEXPGOhJV/43CUcLqBeIXObwLYFGy8Z5DjWTTDQtInPZ8wM0mZAGka5Vy+snHsDAo2pVKYqdIC2lttKIBorFE6OxLOjaFT4Yvps=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(39860400002)(346002)(376002)(136003)(366004)(451199021)(26005)(110136005)(66476007)(66556008)(66946007)(38100700002)(4326008)(921005)(82960400001)(966005)(478600001)(6486002)(6666004)(2906002)(9686003)(6506007)(6512007)(41300700001)(8676002)(7416002)(316002)(54906003)(8936002)(86362001)(5660300002)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NDlEQUxzZExHV1NpZnFCeGNFYTg5MkRJR0xpNkZ6M0FPRUR4QVdHMUZvZURS?=
 =?utf-8?B?bk02d2ZTR3JjSlVkSDcybC83OXRZOTRYRVhXYStWSEhobXI1UWlhR2NmMGJF?=
 =?utf-8?B?M2JkOCtUNnprenFEREM2dXkrM0dBU205QjR6OWQrcHBydVdQVDI4RG8wNWo5?=
 =?utf-8?B?MEhlQnZiVXZYS0l0aUJ4UWQxdFczYnF1Uk50UUtOT1JNRm0ySlJzZGdkaXIv?=
 =?utf-8?B?eVdaOTNxYlZvZmkyVmh4M2NkV25xYm9MTFZPakhQUkFwb1daazBZc3VsZS9G?=
 =?utf-8?B?MVA1bjZEaGhqaWt4cXJXSUNnaXhHbERRN2ZWVVdMa3o2c0pUYzQ2eGp1WXhu?=
 =?utf-8?B?bGlCL2p6STFQM3JxUndnSStsVHJBMHgwWWpoclhKS2VsQ0JlNWYrZmp4TGZw?=
 =?utf-8?B?WWcySkVUOWovYWlvVGVaa3R6Q1YxUlZkTHBuRm1pLzFiNXJTVDlnbEVZUEgz?=
 =?utf-8?B?cFMvVnlOZ0wxQ0ZMWEZDalhQa2lweTIvaDk2M05oZDFDTXVkNFJYL1ZRS0FU?=
 =?utf-8?B?MEpGZ1VORGlhU243aDlLUlNxNzRWZlk0UXhKVTB5SHFQeWNFUUd1SHZPVWtm?=
 =?utf-8?B?OEJXYjk3RDJ5cklBRjM1RGV5ZVV1NG1ZZjhSNnRVMzdtL0xsMWJ4ODF6UkdS?=
 =?utf-8?B?TWRreFVWajNJalJ1SnVOYTd1bmxhN21sQTRIRlB4czJDVEcyVmg0QnJnSUJM?=
 =?utf-8?B?QzhvU0RReTVIckhTOUZ6dEpEOUNOZzR5MEpiTGQrc2pVeWlxSjdaMUNXY25i?=
 =?utf-8?B?M2V3QlF3QXFGSG5pazdpWitnaDFvQmZXUEk2R0ZlOEhvNlgyVW01cEVEWXRW?=
 =?utf-8?B?MG4wWEFnQ0pneDFuRE1ubVA3WUE0ek0yNlNjL3diUnBONE05OSs4Zll6cmFy?=
 =?utf-8?B?TjhHZkFETUlaUDlYbWIvNjNnNjlpcFBzdHBMWGplOXlxQlRWaHhSL094dkZI?=
 =?utf-8?B?MGIyR205MFpUR2l2eFNTQmx2dXZIWkZRSGdhRkVVVDJCN2VNVU1iVUMxU3J6?=
 =?utf-8?B?MzdsNm96YXpYaUJQVktjd1BVTnF4V3VkL0xrN3F4VGpHTnFpK1lueVFVeTBS?=
 =?utf-8?B?WFVGSWlXbGRGd3VHVExSTDVpTE9lQWlHZW8xNDdMZG8vTmpudHVORVVQbGRO?=
 =?utf-8?B?TFJTYVVwbGRDaXdVT2h0aWZOdi9KUHgyb1pVLzFZS1M4OHJBSS9RY2k3TEI1?=
 =?utf-8?B?M0w5VzRXYllnbGNPL25IMjdIcWtzNSs2UnNPREd3L3JvZjdtNHdDcXlWa05l?=
 =?utf-8?B?dFZvUG5hanRHZlhFNWdETWlQRTdmUEN3dHRDTjR3dWJ6UURJcUp5dWhSRDd6?=
 =?utf-8?B?Z2xLUnpIbVJyQno1c1piVXBhMUtvSlBHVWpNcFVLN2hSYzQ2WWszZDM5VVpn?=
 =?utf-8?B?QUdtVHJxcEJnYmlIQStrcHNZQkZqM3JQR2Jpc05JMFFzYmJLbkt1QWl3UTVE?=
 =?utf-8?B?eXIwYXcxeVYzWDdhZ2Y4ZHJTeXlpZkY3Q0FIUnVvUVZlQnordjBSamhROUV3?=
 =?utf-8?B?MnBRa1NjU05WTXMrcU9DNnhmdlo0NDBJSTlLVDZWemxqWjF5V1hjMHViTWtY?=
 =?utf-8?B?aDVTZ05lSnk5b0RJMnAvYWRkMUdSd2Vabk9USVZmd1hnOEF4TFlTUWVoM05N?=
 =?utf-8?B?OUgxWlA1RFpuMC9QNEdzTEcwc2dtdnBOM2gvUll4RHFpSnUwZ21UM0hoZXNY?=
 =?utf-8?B?QXMvMjBIb3paT2YyeXRGb2QzOVV6bW0zUFZYZ1RPOVFRbi9wM0xjWFo0UGtN?=
 =?utf-8?B?a3FQNlJpWHlUaHRycW1mS1M5eEFuWGV2NGt4bG8zeDlTcjg2cVY5WnNSUUE3?=
 =?utf-8?B?RFhueUwzV29tNjk2cmdDY2NQY2dCWEpyektBd0w4SkNLNU5pZi80NjJFTjBS?=
 =?utf-8?B?aXF2M0VNOGlvUU1tUWJZYjFxRDNGQTFQQm1YeTcwNGF6aHlGd1FKcEhqbFFD?=
 =?utf-8?B?VDk3bk54VVVmUFBIc0pONTdBQ3hUaWREQXhzbk5WUWF5K1k0QmEvNkpOSkdB?=
 =?utf-8?B?WFdmVHRYa2pNS3B4bHYvZjJvZzg0MWtSVVNzSGZ2S2huNDQ4Q0NsY3MwNm5R?=
 =?utf-8?B?ajJMWUtLTDNTU0c1b1drVkZWMWx0MWVocEdwYTlUQzY2cUxyak9qMmFaV2R0?=
 =?utf-8?B?cWh4aUI2anJXNzBXM2ZUM3VGc0NCdFFsOFk1ekUrMlM3aGJpNWtxVm8wY2Qr?=
 =?utf-8?B?bnc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 334fe195-f71e-4843-247b-08db6637cd9e
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 02:43:26.4588
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yYfRdWt8OXtRPccrh79vCIk7xWeLhHUGCCXe/AE1v6GWrcxfNN9W+vecbwz8c/OBRHKpCsTDlOrjxSG5Ts/T8xXN1LBZkOG2kE+/SNPSQc8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4785
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[ add Lukas ]

Giani, Dhaval wrote:
> [AMD Official Use Only - General]
> 
> Hi all,
> 
> We have proposed a trusted I/O BoF session at KVM forum this year. I wanted
> to kick off the discussion to maximize the 25 mins we have.
> 
> By trusted I/O, I mean using TDISP to have “trusted” communications with a
> device using something like AMD SEV-TIO [1] or Intel’s TDX connect [2].
>
> Some topics we would like to discuss are
> o What is the device model like?
> o Do we enlighten the PCI subsystem?
> o Do we enlighten device drivers?

One observation in relation to these first questions is something that
has been brewing since SPDM and IDE were discussed at Plumbers 2022.

https://lpc.events/event/16/contributions/1304/

Namely, that there is value in the base specs on the way to the full
vendor TSM implementations. I.e. that if the Linux kernel can aspire to
the role of a TSM it becomes easier to incrementally add proxying to a
platform TSM later. In the meantime, platforms and endpoints that
support CMA / SPDM and PCIe/CXL IDE but not full "trusted I/O" still
gain incremental benefit.

The first proof point for that idea is teaching the PCI core to perform
CMA / SPDM session establishment and provide that result to drivers.

That is what Lukas has been working on after picking up Jonathan's
initial SPDM RFC. I expect the discussion on those forthcoming patches
starts to answer device-model questions around attestation.

> o What does the guest need to know from the device?
> o How does the attestation workflow work?
> o Generic vs vendor specific TSMs
> 
> Some of these topics may be better suited for LPC, 

Maybe, but there's so much to discuss that the more opportunities to
collaborate on the details the better. 

> however we want to get the discussion going from the KVM perspective
> and continue wider discussions at LPC.

While I worry that my points above are more suited to something like a
PCI Micro-conference than a KVM BoF, I think the nature of "trusted I/O"
requires those tribes to talk more to each other.
