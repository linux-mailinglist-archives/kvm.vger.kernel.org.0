Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5552815CE83
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2020 00:09:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727754AbgBMXJW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Feb 2020 18:09:22 -0500
Received: from mail-bn8nam11on2084.outbound.protection.outlook.com ([40.107.236.84]:36800
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726780AbgBMXJW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Feb 2020 18:09:22 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jkaTCPwYZTzO2kgyTuiEz/aCcWqaE5y8P6gXv8Afh4mfchQoz+OOjeUDKE+s0g6a6KnbmDi9n/EKWQ73JFq+v0WrSvri5yoI8DzkDmdT7nab8F0Iq2/kewiG9AymzzqcgwsV6iKLX+4NkV97kpOLPs+ayWbHPVdTSW40tnK0+v/r1busP+rKksPvUw/tD346cxJMd/sgdApWlD9MJh+2MJEALz+9WMdKMtifMl+kZAHpQgc/+WaHspdp7vhcrSS5Ep/mSMwueDPw6MnV6qGzZvsBqhqBL+rM5B8j1dDwhWZvbFOTwyMZikDrIwTVFKsXmyNLy1L6/cxz9whprJbGiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q3vNUy6bhNEdoneOpVv8/qGwSMpnJig9Z1U/0TN5d7A=;
 b=c34W+HSxpuegmL9Zh1GBbN49+mrMC2R1gu4Uo0Ss0Wuu81NRREcVEYalAcCE9im5p53I0lL69iHdb+oZ/rI1AoFritRH4p2uN5y1/TTk5+T1R6WS4PWKvUOBsvix1HR6p/OoFJIA4C8nc8GJ0Rn8gldkQ48/gzhZknmaTZ3jcoePD5d9G6fPvEp1vIEYA0TaT3SDN5mHznkC1B2GoJDbsZNHIEnStqwrFY4dl8psdqkqX09LqYTDVihMQxtSJEHLtoK/UAQejw8H97Xem63uL/g4gVeM7nAtZYAI7l7H+djKK2RfPDI3oPrDch8nww0sDHXmq7xoyizQvVdVpODLAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q3vNUy6bhNEdoneOpVv8/qGwSMpnJig9Z1U/0TN5d7A=;
 b=cuED20UmV+ccVXmIuqxwo/cZdUICsSV6/byTJCbHw21W/tdlecANuVrE+Z3mchKW+kL95ywHOt1yli/nrOL+7/UgNDV4T2z7LM0AbDlGyArU47JQP2Tq3sc4LROZP6TSNTP/Q2jejnlzkSi9QR77AGvUpnb3RgpXQpX+O0tywDc=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Ashish.Kalra@amd.com; 
Received: from SN1PR12MB2528.namprd12.prod.outlook.com (52.132.196.33) by
 SN1PR12MB2351.namprd12.prod.outlook.com (52.132.197.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.22; Thu, 13 Feb 2020 23:09:18 +0000
Received: from SN1PR12MB2528.namprd12.prod.outlook.com
 ([fe80::fd48:9921:dd63:c6e1]) by SN1PR12MB2528.namprd12.prod.outlook.com
 ([fe80::fd48:9921:dd63:c6e1%7]) with mapi id 15.20.2707.030; Thu, 13 Feb 2020
 23:09:18 +0000
Date:   Thu, 13 Feb 2020 23:09:16 +0000
From:   Ashish Kalra <ashish.kalra@amd.com>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Radim Krcmar <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        David Rientjes <rientjes@google.com>, X86 ML <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, brijesh.singh@amd.com
Subject: Re: [PATCH 00/12] SEV Live Migration Patchset.
Message-ID: <20200213230916.GB8784@ashkalra_ubuntu_server>
References: <cover.1581555616.git.ashish.kalra@amd.com>
 <CALCETrXE9cWd3TbBZMsAwmSwWpDYFsicLZ=amHLWsvE0burQSw@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrXE9cWd3TbBZMsAwmSwWpDYFsicLZ=amHLWsvE0burQSw@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: SN1PR12CA0086.namprd12.prod.outlook.com
 (2603:10b6:802:21::21) To SN1PR12MB2528.namprd12.prod.outlook.com
 (2603:10b6:802:28::33)
MIME-Version: 1.0
Received: from ashkalra_ubuntu_server (165.204.77.1) by SN1PR12CA0086.namprd12.prod.outlook.com (2603:10b6:802:21::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2707.29 via Frontend Transport; Thu, 13 Feb 2020 23:09:17 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 42ea5417-0973-4bf5-bf01-08d7b0d9c099
X-MS-TrafficTypeDiagnostic: SN1PR12MB2351:|SN1PR12MB2351:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB2351C7DB4B967ED1DB6DC36A8E1A0@SN1PR12MB2351.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 031257FE13
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(39860400002)(396003)(346002)(376002)(136003)(199004)(189003)(8936002)(53546011)(478600001)(33716001)(44832011)(81156014)(8676002)(81166006)(1076003)(956004)(26005)(316002)(6916009)(54906003)(6496006)(52116002)(33656002)(16526019)(186003)(5660300002)(4326008)(7416002)(9686003)(66476007)(66946007)(66556008)(2906002)(86362001)(55016002);DIR:OUT;SFP:1101;SCL:1;SRVR:SN1PR12MB2351;H:SN1PR12MB2528.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WosHpiu6zs2ufpZgdEY18YBgWws39edNPF29A0/0tSxOFL2uanlRufuewHsS1t8LPEOHPUlh/PTRyUj4jMaEEFlZhh0ELrvqFGP7/iEHKWY2Z5g+0xOPAjsOm1TJmXNAw8UCxUIQG5FRxk8H5Zki7TUZoGMqz7tnTkrMg05KvLSl6gy+eSJlRTeZgJxIkTl/tdz6LVNE7IT1Xd5X4/8D1XF1jd2S1TLtc+UGikPNiJo73C9dFSwk4HQA7jW9Vbqp4nNHavg1ZwdiJwHWfzV66PhWom4ba8BF+X8txPHf2JIhbR8cHW9rhMvV/uugyXeXHtkkFcAr6FziK87Y1As6Q3PhKpfqPl5X0AhWhDecrswb0j5dl5ousDeaIUuxZBlhCf9Xbf/0opIj0xKBSTPQeBC75kHmf/d9FJhGID207cPLn5F6QOcuB5MBkPntyZDV
X-MS-Exchange-AntiSpam-MessageData: 6dWqZzK8LNUTQal7671Qe8D1t8+CRC7oln/rxQfUeNzWZ+xJ+cnoQpN80/DRT91uxzTExRXXuS+4XKsBPe43JnzlbRge8nofb4EgPayon5cYESARdZ9LqwiUXnQ+VZ9WIUaOaF0496NJiQpmgOAw1A==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 42ea5417-0973-4bf5-bf01-08d7b0d9c099
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2020 23:09:18.3986
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +zmNw0aJtE0TV5+cmyr2X+8IwY77dQK0uZPXeH43cC6aJh7IVNpc9rGD7O9zrS7lASAoOyzaxij3XmfsK6IdKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2351
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 12, 2020 at 09:43:41PM -0800, Andy Lutomirski wrote:
> On Wed, Feb 12, 2020 at 5:14 PM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
> >
> > From: Ashish Kalra <ashish.kalra@amd.com>
> >
> > This patchset adds support for SEV Live Migration on KVM/QEMU.
> 
> I skimmed this all and I don't see any description of how this all works.
> 
> Does any of this address the mess in svm_register_enc_region()?  Right
> now, when QEMU (or a QEMU alternative) wants to allocate some memory
> to be used for guest encrypted pages, it mmap()s some memory and the
> kernel does get_user_pages_fast() on it.  The pages are kept pinned
> for the lifetime of the mapping.  This is not at all okay.  Let's see:
> 
>  - The memory is pinned and it doesn't play well with the Linux memory
> management code.  You just wrote a big patch set to migrate the pages
> to a whole different machines, but we apparently can't even migrate
> them to a different NUMA node or even just a different address.  And
> good luck swapping it out.
> 
>  - The memory is still mapped in the QEMU process, and that mapping is
> incoherent with actual guest access to the memory.  It's nice that KVM
> clflushes it so that, in principle, everything might actually work,
> but this is gross.  We should not be exposing incoherent mappings to
> userspace.
> 
> Perhaps all this fancy infrastructure you're writing for migration and
> all this new API surface could also teach the kernel how to migrate
> pages from a guest *to the same guest* so we don't need to pin pages
> forever.  And perhaps you could put some thought into how to improve
> the API so that it doesn't involve nonsensical incoherent mappings.o

As a different key is used to encrypt memory in each VM, the hypervisor
can't simply copy the the ciphertext from one VM to another to migrate
the VM.  Therefore, the AMD SEV Key Management API provides a new sets
of function which the hypervisor can use to package a guest page for
migration, while maintaining the confidentiality provided by AMD SEV.

There is a new page encryption bitmap created in the kernel which 
keeps tracks of encrypted/decrypted state of guest's pages and this
bitmap is updated by a new hypercall interface provided to the guest
kernel and firmware. 

KVM_GET_PAGE_ENC_BITMAP ioctl can be used to get the guest page encryption
bitmap. The bitmap can be used to check if the given guest page is
private or shared.

During the migration flow, the SEND_START is called on the source hypervisor
to create an outgoing encryption context. The SEV guest policy dictates whether
the certificate passed through the migrate-set-parameters command will be
validated. SEND_UPDATE_DATA is called to encrypt the guest private pages.
After migration is completed, SEND_FINISH is called to destroy the encryption
context and make the VM non-runnable to protect it against cloning.

On the target machine, RECEIVE_START is called first to create an
incoming encryption context. The RECEIVE_UPDATE_DATA is called to copy
the received encrypted page into guest memory. After migration has
completed, RECEIVE_FINISH is called to make the VM runnable.

Thanks,
Ashish
