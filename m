Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86968166184
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2020 16:55:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728671AbgBTPzG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Feb 2020 10:55:06 -0500
Received: from mail-dm6nam12on2070.outbound.protection.outlook.com ([40.107.243.70]:17376
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728380AbgBTPzG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Feb 2020 10:55:06 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lkuf0Scj8/zgBrgdSd6DupjmmvGIqswvGBmCsAieZdiAlHrdrtWg40UNsqApn9BkWok8cXxk5oP5g4hW7/z81Nfq1k1zBhTNAjRAPts4lHD1VK4HvUTVgnHpIDhZQQZmEOLT8SNovlm3Y5N5/Fzr5/Yk9JiEOA+CkNBVpS22aWhdcYntUR6aObiT7NFiTRjeoOcywCpOzV7SJ+C7y1PcIeFRR32F5ci7wbd06HOx3b6sVmZ1+/qgIUONdmE/GObxpKpxZ0fg9eZPzOOsddsUvMJlczEETP4Kg/V7G1E/jfZ0ZLmke+mSfPvGwtSaIvFxSxN3fBVxLy/FRLrblkZJVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M4LCJ0+kopJZqsANSh6OFKcPJieqrrhYWMAlSe3J+40=;
 b=XAuy+FE4+/i0wcqJ5gugbn1Q7X22RavxnR5TgmG5NlH5ZyubVX77l09QsJK1At5l/eDbiq0gjwWQDL+n2eYjofZLW9evJTXX3J0+lCpnedbpskHChxonNDeQJ6ygXYPXJ6Mv68UTtyearbeBYEgFomlwIeSNUMegAZlc72O/EeYGVyyKbi+1ivcYl40S4/h9rLZCJb6hbsXaaWMWIhWbVZB5Li7YTMmGYCflTSzjErzeQGU1xvKVofzUXjCkaoHGiZ9CP+7SgYXo3ts+MzFyOqqZ8XUdkfv9ds2m1kAEtHlV3wLq3lof8Tyob+3ISwMwn4ACHftpiskOx9vzd3DFWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M4LCJ0+kopJZqsANSh6OFKcPJieqrrhYWMAlSe3J+40=;
 b=3Ip14znYWKgtKkxzp+D4nE5Uss3eEoXcGLV+Vx4ykcYpfa/GqwtTyZSHBsneqQXEjkIwy/At8wYV9E8EE8ZsfdrfgCvG3h4N1hf5FaeHPWzXIB5boSrzjIRNpuEa6jmjbgJrAndE7k+FiT4HcMKZW3DqHvyW2W+WBOv4Cmi7Xtk=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=brijesh.singh@amd.com; 
Received: from CY4PR12MB1926.namprd12.prod.outlook.com (10.175.59.139) by
 CY4PR12MB1287.namprd12.prod.outlook.com (10.168.168.136) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.25; Thu, 20 Feb 2020 15:55:03 +0000
Received: from CY4PR12MB1926.namprd12.prod.outlook.com
 ([fe80::e5ec:63d5:a9a8:74c4]) by CY4PR12MB1926.namprd12.prod.outlook.com
 ([fe80::e5ec:63d5:a9a8:74c4%12]) with mapi id 15.20.2729.032; Thu, 20 Feb
 2020 15:55:03 +0000
Cc:     brijesh.singh@amd.com, Ashish Kalra <ashish.kalra@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@suse.de>,
        Tom Lendacky <Thomas.Lendacky@amd.com>,
        David Rientjes <rientjes@google.com>, x86@kernel.org,
        KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 10/12] mm: x86: Invoke hypercall when page encryption
 status is changed
To:     Andy Lutomirski <luto@amacapital.net>,
        Steve Rutherford <srutherford@google.com>
References: <CABayD+ch3XBvJgJc+uoF6JSP0qZGq2zKHN-hTc0Vode-pi80KA@mail.gmail.com>
 <52450536-AF7B-4206-8F05-CF387A216031@amacapital.net>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <3de6e962-3277-ddbd-8c78-eaf754973928@amd.com>
Date:   Thu, 20 Feb 2020 09:54:46 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
In-Reply-To: <52450536-AF7B-4206-8F05-CF387A216031@amacapital.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: HK2P15301CA0007.APCP153.PROD.OUTLOOK.COM
 (2603:1096:202:1::17) To CY4PR12MB1926.namprd12.prod.outlook.com
 (2603:10b6:903:11b::11)
MIME-Version: 1.0
Received: from [10.236.31.95] (165.204.77.1) by HK2P15301CA0007.APCP153.PROD.OUTLOOK.COM (2603:1096:202:1::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.3 via Frontend Transport; Thu, 20 Feb 2020 15:54:55 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 647ab5e7-40c8-4573-3c17-08d7b61d3f9a
X-MS-TrafficTypeDiagnostic: CY4PR12MB1287:|CY4PR12MB1287:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR12MB12873136E1B4504E2B4E6B9CE5130@CY4PR12MB1287.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 031996B7EF
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(39860400002)(366004)(396003)(136003)(346002)(199004)(189003)(6666004)(2616005)(956004)(66946007)(316002)(52116002)(44832011)(110136005)(66556008)(186003)(16526019)(54906003)(16576012)(66476007)(5660300002)(36756003)(81166006)(4326008)(31696002)(81156014)(8676002)(53546011)(8936002)(86362001)(26005)(6486002)(478600001)(7416002)(2906002)(31686004);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR12MB1287;H:CY4PR12MB1926.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uYOSg7o4CMN6Nbkrgp0NhYy/FV3dhFw+c6wfgwB09Xq0nq4adkfvDRpAVWCJK5Ne+52sfkhTZfDatS3Qv1H3PpQ5syhmHtXwxBRyQHMYDGVWix/rIzZX/SIn0Ykp6GYLA+j6NWmaJwOjoSs5ZdABWCQm7tguFN5LPsdty1HSjZgSuXsd0cuLHQ9CrKtK6deOd8x6leZKn7q6iu3soFIYjbMuNPdW0TJ2fKeWVHaJs/ePUPq+vDc/1oW3j7jP5gJkj22Qakrv/BEakIVYik2efd2x4h6aEM75l7F9BKcdP9vHstz6dUYtW+GNhBA8RZhHOJeVmVP9nOdF56pd6YEDFj5qDD/SRCbPpkq49acsOQrpOeLplzVOilAtO2PNAldFHOO0MXTxHv+YhV3SgzsB/M5Uyhd6I+iVqBVfdduRCmpNdBmpBIZ7dqrlgFcnRp2g
X-MS-Exchange-AntiSpam-MessageData: 2hYHOEiZov91jEC1cTnRCwgfEncYDyScIBqvR0DEGZijHIKFL6qnStMasPS2b1+Hq1Ls2uSKT+ncKw938jUOG8uHbHRhQyJEgjnodpK1paxS6gab17FhFtDmLTEny42Gqr9GAs2IyYlPMUgZyvKaLg==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 647ab5e7-40c8-4573-3c17-08d7b61d3f9a
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2020 15:55:03.6542
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gN8F6P55bHuULcr6qL8JzlD6m9bjdMoAD8z0tWHIBRjvCqZOoux/Vjjx+KOrSx2eIzCJXq5+AH65uCGTlwrcyg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1287
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/19/20 8:12 PM, Andy Lutomirski wrote:
> 
> 
>> On Feb 19, 2020, at 5:58 PM, Steve Rutherford <srutherford@google.com> wrote:
>>
>> ﻿On Wed, Feb 12, 2020 at 5:18 PM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
>>>
>>> From: Brijesh Singh <brijesh.singh@amd.com>
>>>
>>> Invoke a hypercall when a memory region is changed from encrypted ->
>>> decrypted and vice versa. Hypervisor need to know the page encryption
>>> status during the guest migration.
>>
>> One messy aspect, which I think is fine in practice, is that this
>> presumes that pages are either treated as encrypted or decrypted. If
>> also done on SEV, the in-place re-encryption supported by SME would
>> break SEV migration. Linux doesn't do this now on SEV, and I don't
>> have an intuition for why Linux might want this, but we will need to
>> ensure it is never done in order to ensure that migration works down
>> the line. I don't believe the AMD manual promises this will work
>> anyway.
>>
>> Something feels a bit wasteful about having all future kernels
>> universally announce c-bit status when SEV is enabled, even if KVM
>> isn't listening, since it may be too old (or just not want to know).
>> Might be worth eliding the hypercalls if you get ENOSYS back? There
>> might be a better way of passing paravirt config metadata across than
>> just trying and seeing if the hypercall succeeds, but I'm not super
>> familiar with it.
> 
> I actually think this should be a hard requirement to merge this. The host needs to tell the guest that it supports this particular migration strategy and the guest needs to tell the host that it is using it.  And the guest needs a way to tell the host that it’s *not* using it right now due to kexec, for example.
> 
> I’m still uneasy about a guest being migrated in the window where the hypercall tracking and the page encryption bit don’t match.  I guess maybe corruption in this window doesn’t matter?
> 

I don't think there is a corruption issue here. Let's consider the below
case:

1) A page is transmitted as C=1 (encrypted)

2) During the migration window, the page encryption bit is changed
  to C=0 (decrypted)

3) #2 will cause a change in page table memory, thus dirty memory
  the tracker will create retransmission of the page table memory.

4) The page itself will not be re-transmitted because there was
  no change to the content of the page.

On destination, the read from the page will get the ciphertext.

The encryption bit change in the page table is used on the next access.
The user of the page needs to ensure that data is written with the
correct encryption bit before reading.

thanks
