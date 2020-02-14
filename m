Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A70EF15CFB0
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2020 03:10:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728348AbgBNCKM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Feb 2020 21:10:12 -0500
Received: from mail-bn8nam12on2085.outbound.protection.outlook.com ([40.107.237.85]:6037
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727955AbgBNCKL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Feb 2020 21:10:11 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cSM6ye1+adxzez244uPAX9shoyMjlVEVvbvBeeS3Uuup3LbWiSBC+CpmmvuCwp7uyHTqQeG+wf6da5iJo3POXJ4QqpKzOqF0s7qhUjSFz0nirj/m7p+CDOHQmEZM+MgVwr4v4Maike/nQ9U58w8US8hC3ivqrYcjyFlR2irybf/b6mM6XVDuy629iIQhLViNdrI1GxOkT9HQIS8iUdZS78rrUnvk87Cml4PietY4b7wTU8tcgFGSibQCFyvYTKdocDkiQP6rzBAVAkGjOK/8WoR8ec8WkDeUm/qjxvovLRGWBhqV95WFrpeaXyo3qmJ0S9nT+zHVVnnx3U9F8KeGUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lj2a4p64LeqcBY9D2N6/2sdp4qCfo59ACXy9epV3XYg=;
 b=Zp0JwlVfYB8Cg0WQx/YS6+ehh6pjEv6RgXRkktmjw8zeXvqCwuhWVPFaJvLbfUnyHGP/J64Mo1b41tAfoVaDgEVTHnH+Un7fHTw5IgAcxhGIYrtVmyqRzayuvAPIX8kGN4wYtKscjGf5366i3JWakSoaDjTnU2fmqXbAgWDGIe8eY27zdzB/bHeRWybQb5IUQy25GOdRm+5RTZOeg0+Naq5yIrJ3OlFV2LmuH4XFb46Kwjwb5p0Ac+YPn17anoozmrulfL8j41cFKW7cdPLO2vNwcDrXc4TWUwTpaHb/3KamGHr3EbP96Te50g7C0mqeSo9VG2mEaRhF4oAbRA+6Ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lj2a4p64LeqcBY9D2N6/2sdp4qCfo59ACXy9epV3XYg=;
 b=ftgWG29XoI/NjoSAjMeVibsxr/fNRMl68DYp8N8w5XlKkI0EEsMezbsFV3iMoR5cj7KjnmbO8scdynKl2IcisL8SmHzzUQlshDI5xwi4pO97aEdcVd/3WpkuicfkYGeCknL6R4TmAnafFKevZvjtW0lXZKJs9oRY/84wPEsGX08=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=brijesh.singh@amd.com; 
Received: from CY4PR12MB1926.namprd12.prod.outlook.com (10.175.59.139) by
 CY4PR12MB1799.namprd12.prod.outlook.com (10.175.60.9) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.23; Fri, 14 Feb 2020 02:10:08 +0000
Received: from CY4PR12MB1926.namprd12.prod.outlook.com
 ([fe80::e5ec:63d5:a9a8:74c4]) by CY4PR12MB1926.namprd12.prod.outlook.com
 ([fe80::e5ec:63d5:a9a8:74c4%12]) with mapi id 15.20.2729.025; Fri, 14 Feb
 2020 02:10:08 +0000
Cc:     Andy Lutomirski <luto@kernel.org>, brijesh.singh@amd.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Radim Krcmar <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        David Rientjes <rientjes@google.com>, X86 ML <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Dave Hansen <dave.hansen@intel.com>
Subject: Re: [PATCH 00/12] SEV Live Migration Patchset.
To:     Ashish Kalra <Ashish.Kalra@amd.com>
References: <cover.1581555616.git.ashish.kalra@amd.com>
 <CALCETrXE9cWd3TbBZMsAwmSwWpDYFsicLZ=amHLWsvE0burQSw@mail.gmail.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <e49085c0-3a83-6301-d22e-7aadf8ee5a33@amd.com>
Date:   Thu, 13 Feb 2020 20:10:05 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.1
In-Reply-To: <CALCETrXE9cWd3TbBZMsAwmSwWpDYFsicLZ=amHLWsvE0burQSw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: SN4PR0701CA0044.namprd07.prod.outlook.com
 (2603:10b6:803:2d::17) To CY4PR12MB1926.namprd12.prod.outlook.com
 (2603:10b6:903:11b::11)
MIME-Version: 1.0
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by SN4PR0701CA0044.namprd07.prod.outlook.com (2603:10b6:803:2d::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2729.25 via Frontend Transport; Fri, 14 Feb 2020 02:10:06 +0000
X-Originating-IP: [70.112.153.56]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5aa76803-3495-40b4-6e04-08d7b0f30386
X-MS-TrafficTypeDiagnostic: CY4PR12MB1799:|CY4PR12MB1799:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR12MB1799CA9A4133E97271A2E9BBE5150@CY4PR12MB1799.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 03137AC81E
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(346002)(376002)(39860400002)(366004)(189003)(199004)(7416002)(81166006)(66556008)(956004)(37006003)(54906003)(66476007)(8936002)(6486002)(52116002)(6512007)(36756003)(26005)(2906002)(66946007)(81156014)(8676002)(31696002)(316002)(86362001)(5660300002)(4326008)(186003)(6862004)(6506007)(53546011)(478600001)(6636002)(966005)(16526019)(4744005)(2616005)(44832011)(31686004)(6606295002);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR12MB1799;H:CY4PR12MB1926.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hSK/AcTwCk6NILemrk0SJBJWkQSFVFMFeFfSGGQFgfNaIu5fZ2ZNqhVDmU4/rY/dPwc4JFPSJlpQkQtmLtjNlD2zyKVK3wemQrq9aKNHj97x/wbazc94gR3esPgdUH0WzTazYCDnQpHBBmyDb2+Duyc2Qyud58POYRg6e927sakWLZgBso8wdzSTf59oFModBJwhppGzrN7XrQOVMfubl/q190V7ZLOuA5toHkH290vpU00ITrF9pCDXc/vCAv0WVN8EsmGWZ9w+BqSqZ/nJQSGRQV7cOxzxrk8eJfYuxIoVB0D2+uAXgUoYYT7n84YYHuhoDZO+v3Ls1S+rc/9b5X0JjXyvJ1lkW5RXL+b3bMFgsMImcByscNdn4DiE8w4dyvHG4zYGMHWcEpicVXCwVPvTyF0ePqxb2VbRHkrzKd5Pci9mChIAyrLF6o6P7qduo8nDLk82cBEdaC98Ax5ptWyBAHHjfmd+DsosgUV5mHvLSBr1YWVF202NFO5eWMvhGEk9WWViQ9uVm6ujxhTFwl5tR7iOk4LbQWjiCYJnV9OdnXRgdOiBk+8QDCMk1Lic
X-MS-Exchange-AntiSpam-MessageData: hz53ANS/DSMpXWcor6iuK9taV0e+/zwSPT2ZkKIzqxSEvR7p0csET1oTPiq4xCEkVSVQ0On1hfgYeltLMOGP6C00k6PHJu5ho0w9yy+XCCA0SINYGqs9Hc0P5jgIGeaKtajX1DAujFbt2AFTK4IinA==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5aa76803-3495-40b4-6e04-08d7b0f30386
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2020 02:10:08.1166
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wKnQ8+QFhty0WsKCknVSdvtp6wnfIWFemX6ux7DB7kHgoNk2G1MxfpdN7L+xtRE7lCrJruOHcE+ALknikBTypA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1799
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Ashish,


On 2/12/20 11:43 PM, Andy Lutomirski wrote:
> On Wed, Feb 12, 2020 at 5:14 PM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
>> From: Ashish Kalra <ashish.kalra@amd.com>
>>
>> This patchset adds support for SEV Live Migration on KVM/QEMU.


I think you should some explanation in cover letter so that we get the
full context of the patch. You can see a reference cover-letter in
previous submissions.

https://marc.info/?l=kvm&m=156278967226011&w=2

The patch series is also missing the revision number and change log,
these information will helper reviewer to know what is changed since
previous version and which feedback are addressed in this version. 

Thanks
