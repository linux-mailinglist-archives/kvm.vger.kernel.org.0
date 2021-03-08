Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 765C2331967
	for <lists+kvm@lfdr.de>; Mon,  8 Mar 2021 22:34:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230169AbhCHVdf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 16:33:35 -0500
Received: from mail-bn7nam10on2048.outbound.protection.outlook.com ([40.107.92.48]:60575
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229488AbhCHVdJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Mar 2021 16:33:09 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iKzlst0gjygbCDRvgGzQjYVewKXZ8L9nzgMrMnXX9R6J5pwXkPHsxHtymCdS+3HRFXd4KpXbnmZw9z/sIAiRga3c4Z3+a8DnTI5fJwTIA+Mb4nKzo6nsAhZThsx3E6BuujCMbUact1lDg5A4IR4JgW1YfCsr9K+ELROePUrL0WTHswuZC2+uGO18QKIUg/o5eZkqZB2u+zJvB912/dzFIuSCcbYwCSKcfYW99RJjPF70Csfu41jwHBiMIdmgE4GckeZPn6UZfe2QnVEHGsTflkb05ox+1rnq5HPjDkWELgDiuHl4i/Rtu+8De/QAsbXuj+DoZSMLaErCWwKqsU22hQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZTIQemop5Haz7XTg/vDhIoRgTHpuwgJcAbQBiiCt5EI=;
 b=A2pGUDLGdluVZ49TKz5utmA6G53Ewg7H02mLbaN/rZM4A9pwr7oi6TNu8h3HyuFySsERGjofEDFUx6IH+PAhZ30y/4dpOQ6qhmtrLFCoKwSaO1FJEtcaVodwY+10SIICjjlm2rgWAxI3FvGrwLWyg19idpfjL5ipEmLxar3anZwi1nfU14HBwD6yKMJmhJCTv++JxRQUpJz47aahSwGNKMTgCv+7NFTpBnygcXz3rRhPJIGc4x3m+1epDPKv7IB/UCbqxhPvIc3sSzBoBFerxJydyHedU2BMpY+1MBOXKNvArHIK1p7ieXQJTl62m1RrmhpfZNmKKV4Xb1GwP8nc8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZTIQemop5Haz7XTg/vDhIoRgTHpuwgJcAbQBiiCt5EI=;
 b=LsrHWd9Ne+Z9lTYCWVyUEQmDxzjrei7PpbJ6AfMPqFTpZQ5RXN5q0cIGUtzIpHFrkk4AaS0zoVGI4Fdbf1cwLg6Tq43s1wH80Q0w30KvpzZsGk2KayMHzVv77WdnybBYlnPxttqtIcaMezIl52E+m5sbKhA69go2jnSGy6+Fqqg=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4430.namprd12.prod.outlook.com (2603:10b6:806:70::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.20; Mon, 8 Mar
 2021 21:33:05 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e%7]) with mapi id 15.20.3912.027; Mon, 8 Mar 2021
 21:33:05 +0000
Date:   Mon, 8 Mar 2021 21:32:58 +0000
From:   Ashish Kalra <ashish.kalra@amd.com>
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Steve Rutherford <srutherford@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "venu.busireddy@oracle.com" <venu.busireddy@oracle.com>,
        Will Deacon <will@kernel.org>,
        Quentin Perret <qperret@google.com>
Subject: Re: [PATCH v10 10/16] KVM: x86: Introduce KVM_GET_SHARED_PAGES_LIST
 ioctl
Message-ID: <20210308213258.GA5580@ashkalra_ubuntu_server>
References: <SN6PR12MB27672FF8358D122EDD8CC0188E859@SN6PR12MB2767.namprd12.prod.outlook.com>
 <20210224175122.GA19661@ashkalra_ubuntu_server>
 <YDaZacLqNQ4nK/Ex@google.com>
 <20210225202008.GA5208@ashkalra_ubuntu_server>
 <CABayD+cn5e3PR6NtSWLeM_qxs6hKWtjEx=aeKpy=WC2dzPdRLw@mail.gmail.com>
 <20210226140432.GB5950@ashkalra_ubuntu_server>
 <YDkzibkC7tAYbfFQ@google.com>
 <20210308104014.GA5333@ashkalra_ubuntu_server>
 <YEaAXXGZH0uSMA3v@google.com>
 <bdf0767f-c2c4-5863-fd0d-352a3f68f7f9@amd.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <bdf0767f-c2c4-5863-fd0d-352a3f68f7f9@amd.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN7PR04CA0014.namprd04.prod.outlook.com
 (2603:10b6:806:f2::19) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server (165.204.77.1) by SN7PR04CA0014.namprd04.prod.outlook.com (2603:10b6:806:f2::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Mon, 8 Mar 2021 21:33:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5f1dcd6e-cf31-4599-35b2-08d8e279c253
X-MS-TrafficTypeDiagnostic: SA0PR12MB4430:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB44300DD4F08FF77F3872FC5A8E939@SA0PR12MB4430.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kWTcwakzmFortB7PUPwbgy+ArKYZAC94QnxNNHfzqQBRufN3yuQBmKl/BZf39gEgow7XgLTL8AjNsoRLdhOipt+4qEORGWNACu35DkCaYAcxPlmWmUxnR2eyHHwLBxC+YPtgkkgy3PqguuGpCpmazc1pVVL61GK7ijEgkHyq8MEZ7Tjg5fHC4uCsbWTCm+yT/oCObr53mzOmev/poIKpVK0NGKAIDnsmVhcRrQ+K1crQaktrzFVorZXiNQB/JYAwI7LpFxDawg9FBuxVqHT0XNBlcSZhHH5Mv6Z41PJFHe/r2V+cS3L/O4x9s/l+wBGP0t2CtqCmH3dFs5XtNCJxPn8oLMjekRRUSgxhpcf36EEO2jYEsiacl1V4aXt2UTfz+TsW0lJCD6tq2NLThWQ/VEOLg4PI1fNpkg4AHdE6hPciCRUJxm3xAgi7xbL3IhY+QOmVgmhCY6r5JRkD2KfKM01Fh8/bD7Nc1ZC8r5tThq0FVUtC+mjZOnRM5AWmh8TLRt6s7awHee+bOuaw7FsRPQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(136003)(396003)(346002)(366004)(66476007)(4326008)(33716001)(6636002)(55016002)(66946007)(8676002)(6496006)(2906002)(186003)(9686003)(478600001)(8936002)(5660300002)(6666004)(1076003)(53546011)(66556008)(6862004)(26005)(956004)(33656002)(44832011)(86362001)(54906003)(52116002)(316002)(16526019)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?iso-8859-1?Q?JPe/0H1ucGE0aWqwtw6cuimdwR4sfvbEpXfhyAk+fardXfmdw9+sfC9pYn?=
 =?iso-8859-1?Q?HX2E3nPa41zw6eZL9oHKSm9bYTPtguDPdiXuZV4VpTD7yUe0T3cTaCDYVj?=
 =?iso-8859-1?Q?LMyh3zj2twEVmsVM5Rrnc/9Xpso2cwtPY67wDrlc1ylNOlUNRS11s5AgEN?=
 =?iso-8859-1?Q?NAGg4tZGFr3Gd4OGEdTRfv07vFQkrCbwK7hO4394kzVNzzcD4btsjPH4RC?=
 =?iso-8859-1?Q?lHwx9YfWzP1hJ/6m32z0fg0Ugp7+eXAB1BrNtjsRFRCtk5e2C7IouyY7CV?=
 =?iso-8859-1?Q?NPHly7JHDWDRuKWIgyzl9yuXGGfXc/+ab0RNioitIWLrdv2glZslBENv1D?=
 =?iso-8859-1?Q?mC4LOIObvi93upXvhSzuoZiFt9QD18EpmwamtLgObBvL2drDu3OVBoLs8F?=
 =?iso-8859-1?Q?iLAWjdDIsNIiDJin8xkCX4eSlR9TF24R9hoOi/lZouIlWhvbC818Nm+yEK?=
 =?iso-8859-1?Q?dEsfu63iiA9rZpov/eXu8XsyyqjmPhel1yw2AkjXgg/0LI0+utPJ+Tsd49?=
 =?iso-8859-1?Q?A6JaH59vOJ10/SgVhrSJj7z/DXQM/Jp5PfYRfgxzOSfNVaeBcwarB+iJhh?=
 =?iso-8859-1?Q?4iQqVb3+QK7jhQZ9FDB8yXaz2FKSGQ9rp57Ewbr/q2H9rtkryxIgTOeT1K?=
 =?iso-8859-1?Q?IcvDDJWWYZcNdc5AqiiLWs/2HgA3wxP6kNprbqdvyKz+ezXKXs4vjdoP7V?=
 =?iso-8859-1?Q?fV7menpgPpx9C5MrXw6jopziBGH1jz6r1WkdVQEBZ7U8+pHJ1he2eIUYUB?=
 =?iso-8859-1?Q?twrjWPgOIPz5CfDgHESGBHUajgjxslV0uTcuYrPvSYb272JRQoow1wk4Zu?=
 =?iso-8859-1?Q?7RDsaeSlN6JZwNj4sziRB0DnOx3/hYygO7O6Pg5jXGtujmIw9y22ubrJXq?=
 =?iso-8859-1?Q?yFWGRcKbSsZac4/nFRimmv7ot2z0cKRoPP5VZliM3My1i18EjtHOubw8wp?=
 =?iso-8859-1?Q?VBaC++lZaA/W8nvJJ8mwTEDNbchIeXGQkLNJ1vEkcTgUDFwnYfW1k4acBE?=
 =?iso-8859-1?Q?nsRbY1DBOZ9F4AkWvY1TYpI9OIRC6qosdITYLDw/5VjRNuoIL/cKZyKntQ?=
 =?iso-8859-1?Q?RMOZtyovXtBltp9Kmo2t9fFH1Q2ldHH1rQ91Hk+hCi8gntplfo14Db5QTz?=
 =?iso-8859-1?Q?fGGMaz2GRMviyDhZcrf7c0pxDDT+cyGX9guimsj9QULr+BdOL+osEzT7Ws?=
 =?iso-8859-1?Q?qs0Xgo0NnW2LIWcc8mZM+lxyo32bO0FSg/suFLLhoqXAAjPw7VinNkrFyY?=
 =?iso-8859-1?Q?8SKgfKRkz+meFRk/xQslOzkzxhks+URTNR9cKYVVgMWNOUk12L3rgVgWBN?=
 =?iso-8859-1?Q?r9JyAhfNICx/B0V33roquEdK+7AXM1HGrkXdqSmc7BdR9Djl+vDPhUhgRY?=
 =?iso-8859-1?Q?xnblvoUaxt?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f1dcd6e-cf31-4599-35b2-08d8e279c253
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2021 21:33:05.3897
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: czE4JUOBhMZnK5rRFpGSJGHrEjEhSpD6XXwcNUsM9trqriG4xHwDhXilnagp+vxgNQ2TrwP7Ii79YxVgTd7gCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4430
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 08, 2021 at 03:11:41PM -0600, Brijesh Singh wrote:
> 
> On 3/8/21 1:51 PM, Sean Christopherson wrote:
> > On Mon, Mar 08, 2021, Ashish Kalra wrote:
> >> On Fri, Feb 26, 2021 at 09:44:41AM -0800, Sean Christopherson wrote:
> >>> +Will and Quentin (arm64)
> >>>
> >>> Moving the non-KVM x86 folks to bcc, I don't they care about KVM details at this
> >>> point.
> >>>
> >>> On Fri, Feb 26, 2021, Ashish Kalra wrote:
> >>>> On Thu, Feb 25, 2021 at 02:59:27PM -0800, Steve Rutherford wrote:
> >>>>> On Thu, Feb 25, 2021 at 12:20 PM Ashish Kalra <ashish.kalra@amd.com> wrote:
> >>>>> Thanks for grabbing the data!
> >>>>>
> >>>>> I am fine with both paths. Sean has stated an explicit desire for
> >>>>> hypercall exiting, so I think that would be the current consensus.
> >>> Yep, though it'd be good to get Paolo's input, too.
> >>>
> >>>>> If we want to do hypercall exiting, this should be in a follow-up
> >>>>> series where we implement something more generic, e.g. a hypercall
> >>>>> exiting bitmap or hypercall exit list. If we are taking the hypercall
> >>>>> exit route, we can drop the kvm side of the hypercall.
> >>> I don't think this is a good candidate for arbitrary hypercall interception.  Or
> >>> rather, I think hypercall interception should be an orthogonal implementation.
> >>>
> >>> The guest, including guest firmware, needs to be aware that the hypercall is
> >>> supported, and the ABI needs to be well-defined.  Relying on userspace VMMs to
> >>> implement a common ABI is an unnecessary risk.
> >>>
> >>> We could make KVM's default behavior be a nop, i.e. have KVM enforce the ABI but
> >>> require further VMM intervention.  But, I just don't see the point, it would
> >>> save only a few lines of code.  It would also limit what KVM could do in the
> >>> future, e.g. if KVM wanted to do its own bookkeeping _and_ exit to userspace,
> >>> then mandatory interception would essentially make it impossible for KVM to do
> >>> bookkeeping while still honoring the interception request.
> >>>
> >>> However, I do think it would make sense to have the userspace exit be a generic
> >>> exit type.  But hey, we already have the necessary ABI defined for that!  It's
> >>> just not used anywhere.
> >>>
> >>> 	/* KVM_EXIT_HYPERCALL */
> >>> 	struct {
> >>> 		__u64 nr;
> >>> 		__u64 args[6];
> >>> 		__u64 ret;
> >>> 		__u32 longmode;
> >>> 		__u32 pad;
> >>> 	} hypercall;
> >>>
> >>>
> >>>>> Userspace could also handle the MSR using MSR filters (would need to
> >>>>> confirm that).  Then userspace could also be in control of the cpuid bit.
> >>> An MSR is not a great fit; it's x86 specific and limited to 64 bits of data.
> >>> The data limitation could be fudged by shoving data into non-standard GPRs, but
> >>> that will result in truly heinous guest code, and extensibility issues.
> >>>
> >>> The data limitation is a moot point, because the x86-only thing is a deal
> >>> breaker.  arm64's pKVM work has a near-identical use case for a guest to share
> >>> memory with a host.  I can't think of a clever way to avoid having to support
> >>> TDX's and SNP's hypervisor-agnostic variants, but we can at least not have
> >>> multiple KVM variants.
> >>>
> >> Potentially, there is another reason for in-kernel hypercall handling
> >> considering SEV-SNP. In case of SEV-SNP the RMP table tracks the state
> >> of each guest page, for instance pages in hypervisor state, i.e., pages
> >> with C=0 and pages in guest valid state with C=1.
> >>
> >> Now, there shouldn't be a need for page encryption status hypercalls on 
> >> SEV-SNP as KVM can track & reference guest page status directly using 
> >> the RMP table.
> > Relying on the RMP table itself would require locking the RMP table for an
> > extended duration, and walking the entire RMP to find shared pages would be
> > very inefficient.
> >
> >> As KVM maintains the RMP table, therefore we will need SET/GET type of
> >> interfaces to provide the guest page encryption status to userspace.
> > Hrm, somehow I temporarily forgot about SNP and TDX adding their own hypercalls
> > for converting between shared and private.  And in the case of TDX, the hypercall
> > can't be trusted, i.e. is just a hint, otherwise the guest could induce a #MC in
> > the host.
> >
> > But, the different guest behavior doesn't require KVM to maintain a list/tree,
> > e.g. adding a dedicated KVM_EXIT_* for notifying userspace of page encryption
> > status changes would also suffice.  
> >
> > Actually, that made me think of another argument against maintaining a list in
> > KVM: there's no way to notify userspace that a page's status has changed.
> > Userspace would need to query KVM to do GET_LIST after every GET_DIRTY.
> > Obviously not a huge issue, but it does make migration slightly less efficient.
> >
> > On a related topic, there are fatal race conditions that will require careful
> > coordination between guest and host, and will effectively be wired into the ABI.
> > SNP and TDX don't suffer these issues because host awareness of status is atomic
> > with respect to the guest actually writing the page with the new encryption
> > status.
> >
> > For SEV live migration...
> >
> > If the guest does the hypercall after writing the page, then the guest is hosed
> > if it gets migrated while writing the page (scenario #1):
> >
> >   vCPU                 Userspace
> >   zero_bytes[0:N]
> >                        <transfers written bytes as private instead of shared>
> > 		       <migrates vCPU>
> >   zero_bytes[N+1:4095]
> >   set_shared (dest)
> >   kaboom!
> 
> 
> Maybe I am missing something, this is not any different from a normal
> operation inside a guest. Making a page shared/private in the page table
> does not update the content of the page itself. In your above case, I
> assume zero_bytes[N+1:4095] are written by the destination VM. The
> memory region was private in the source VM page table, so, those writes
> will be performed encrypted. The destination VM later changed the memory
> to shared, but nobody wrote to the memory after it has been transitioned
> to the  shared, so a reader of the memory should get ciphertext and
> unless there was a write after the set_shared (dest).
> 
> 
> > If userspace does GET_DIRTY after GET_LIST, then the host would transfer bad
> > data by consuming a stale list (scenario #2):
> >
> >   vCPU               Userspace
> >                      get_list (from KVM or internally)
> >   set_shared (src)
> >   zero_page (src)
> >                      get_dirty
> >                      <transfers private data instead of shared>
> >                      <migrates vCPU>
> >   kaboom!
> 
> 
> I don't remember how things are done in recent Ashish Qemu/KVM patches
> but in previous series, the get_dirty() happens before the querying the
> encrypted state. There was some logic in VMM to resync the encrypted
> bitmap during the final migration stage and perform any additional data
> transfer since last sync.
> 
> 

Yes, we do that and in fact, we added logic in VMM to resync the
encrypted bitmap after every migration iteration and if there is a
difference in encrypted page states, then we perform additional data
transfers corresponding to those changes.

Thanks,
Ashish

