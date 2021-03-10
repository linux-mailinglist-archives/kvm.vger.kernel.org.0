Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ED0D3333F4
	for <lists+kvm@lfdr.de>; Wed, 10 Mar 2021 04:49:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231993AbhCJDse (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Mar 2021 22:48:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231175AbhCJDsE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Mar 2021 22:48:04 -0500
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57875C061760
        for <kvm@vger.kernel.org>; Tue,  9 Mar 2021 19:48:04 -0800 (PST)
Received: by mail-il1-x129.google.com with SMTP id h18so14280405ils.2
        for <kvm@vger.kernel.org>; Tue, 09 Mar 2021 19:48:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Ry2VwUF3H+Dyy7z8FInA0z451jNOET0hq4JeSLr2Jw4=;
        b=UVSnRrtE43Jks5iUAOlGPEOwwRWlqyDAH1+CUXlTtgkj2GfZ6kC3/1rgdzIHbhkQJj
         g1kL87FPi9mklgmAKAsg1b1UUigDawSInQrzpVD6CNqpyUimrBKWE4IftY4A6lO7KYUf
         iEIjJAj2c52jSkfUiN9w3ymvO0r31jsaYgLljS7CJbcsZh5ybtANfxPStxBSpUzDENmj
         8gj7CIbSz96umU8mqDjBxRFNtgUfDENz7LCWQ9hWOntKfs19HXKrjVGl4TILMW09inWf
         lXfOQ/SkybbLGq88tVtaUHnpz6NG/Ci0WiL3yLa5/dFJ1ruvqcmTos0rimowcXpe/soy
         okbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Ry2VwUF3H+Dyy7z8FInA0z451jNOET0hq4JeSLr2Jw4=;
        b=Jr6myOuZKWS/0z3w1XkwwmRms1hpL/heXuqwRNbg2BUNgnKbMSgTFOEsPjwHSgVg1b
         sBfKu67sQ69n0kd76+hGvXrZh8spzVKm7CT3zqBXNx165L1O8CmfqemwgjUKVSmM4MBM
         1Sz4BZycbeazHL6MSDYlHkDEdzHmgQCFSMfk4YFSH+h/aVeBF92LrGP4FuXJPUw60xWr
         +sZIHiS75KqbLcSC6ueRzTSGNQOxycplxvYKi/m46Y470MrIG5lKiuIQdVWBA9sCeZsX
         sn11FyrsENeedzHnLzsKVNWo/2XA9nYtbjhDy0F8oBkBiYspB+do4yriYtIUrsxlsZ3J
         QY/g==
X-Gm-Message-State: AOAM5307TDPK8jYAgaJCsPkqtHX88R9TP+8ianw+jjMys2kKy7Bxk3z+
        /DrmE5rYuEvhQw/mdQBdtd6Q9U8SDGo1LNDvTmzPlw==
X-Google-Smtp-Source: ABdhPJyINiR4QFryPzcCN7fKWXkuisQNTdF58oY+/aNr/SqhnvTnZQ3haFVAv3ll4nHDoPIJnukTKHJaEpt7pCy4Up8=
X-Received: by 2002:a05:6e02:1a4d:: with SMTP id u13mr1221281ilv.176.1615348083355;
 Tue, 09 Mar 2021 19:48:03 -0800 (PST)
MIME-Version: 1.0
References: <7266edd714add8ec9d7f63eddfc9bbd4d789c213.1612398155.git.ashish.kalra@amd.com>
 <YCxrV4u98ZQtInOE@google.com> <SN6PR12MB27672FF8358D122EDD8CC0188E859@SN6PR12MB2767.namprd12.prod.outlook.com>
 <20210224175122.GA19661@ashkalra_ubuntu_server> <YDaZacLqNQ4nK/Ex@google.com>
 <20210225202008.GA5208@ashkalra_ubuntu_server> <CABayD+cn5e3PR6NtSWLeM_qxs6hKWtjEx=aeKpy=WC2dzPdRLw@mail.gmail.com>
 <20210226140432.GB5950@ashkalra_ubuntu_server> <YDkzibkC7tAYbfFQ@google.com>
 <20210308104014.GA5333@ashkalra_ubuntu_server> <YEaAXXGZH0uSMA3v@google.com>
 <bdf0767f-c2c4-5863-fd0d-352a3f68f7f9@amd.com> <CABayD+ftv5DNdXj-Bs8MXGeFNKx7-aTt99fPuD2R6w1mJ2u8TQ@mail.gmail.com>
 <F3B77ECE-8C70-47AA-98F8-0C032CB5F568@amd.com>
In-Reply-To: <F3B77ECE-8C70-47AA-98F8-0C032CB5F568@amd.com>
From:   Steve Rutherford <srutherford@google.com>
Date:   Tue, 9 Mar 2021 19:47:26 -0800
Message-ID: <CABayD+d9DkHV9tnpPfKXgzGiQ27+K=21R1HhOpjLpks6zgoGUw@mail.gmail.com>
Subject: Re: [PATCH v10 10/16] KVM: x86: Introduce KVM_GET_SHARED_PAGES_LIST ioctl
To:     "Kalra, Ashish" <Ashish.Kalra@amd.com>
Cc:     "Singh, Brijesh" <brijesh.singh@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "venu.busireddy@oracle.com" <venu.busireddy@oracle.com>,
        Will Deacon <will@kernel.org>,
        Quentin Perret <qperret@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 9, 2021 at 7:42 PM Kalra, Ashish <Ashish.Kalra@amd.com> wrote:
>
>
>
> > On Mar 9, 2021, at 3:22 AM, Steve Rutherford <srutherford@google.com> w=
rote:
> >
> > =EF=BB=BFOn Mon, Mar 8, 2021 at 1:11 PM Brijesh Singh <brijesh.singh@am=
d.com> wrote:
> >>
> >>
> >>> On 3/8/21 1:51 PM, Sean Christopherson wrote:
> >>> On Mon, Mar 08, 2021, Ashish Kalra wrote:
> >>>> On Fri, Feb 26, 2021 at 09:44:41AM -0800, Sean Christopherson wrote:
> >>>>> +Will and Quentin (arm64)
> >>>>>
> >>>>> Moving the non-KVM x86 folks to bcc, I don't they care about KVM de=
tails at this
> >>>>> point.
> >>>>>
> >>>>> On Fri, Feb 26, 2021, Ashish Kalra wrote:
> >>>>>> On Thu, Feb 25, 2021 at 02:59:27PM -0800, Steve Rutherford wrote:
> >>>>>>> On Thu, Feb 25, 2021 at 12:20 PM Ashish Kalra <ashish.kalra@amd.c=
om> wrote:
> >>>>>>> Thanks for grabbing the data!
> >>>>>>>
> >>>>>>> I am fine with both paths. Sean has stated an explicit desire for
> >>>>>>> hypercall exiting, so I think that would be the current consensus=
.
> >>>>> Yep, though it'd be good to get Paolo's input, too.
> >>>>>
> >>>>>>> If we want to do hypercall exiting, this should be in a follow-up
> >>>>>>> series where we implement something more generic, e.g. a hypercal=
l
> >>>>>>> exiting bitmap or hypercall exit list. If we are taking the hyper=
call
> >>>>>>> exit route, we can drop the kvm side of the hypercall.
> >>>>> I don't think this is a good candidate for arbitrary hypercall inte=
rception.  Or
> >>>>> rather, I think hypercall interception should be an orthogonal impl=
ementation.
> >>>>>
> >>>>> The guest, including guest firmware, needs to be aware that the hyp=
ercall is
> >>>>> supported, and the ABI needs to be well-defined.  Relying on usersp=
ace VMMs to
> >>>>> implement a common ABI is an unnecessary risk.
> >>>>>
> >>>>> We could make KVM's default behavior be a nop, i.e. have KVM enforc=
e the ABI but
> >>>>> require further VMM intervention.  But, I just don't see the point,=
 it would
> >>>>> save only a few lines of code.  It would also limit what KVM could =
do in the
> >>>>> future, e.g. if KVM wanted to do its own bookkeeping _and_ exit to =
userspace,
> >>>>> then mandatory interception would essentially make it impossible fo=
r KVM to do
> >>>>> bookkeeping while still honoring the interception request.
> >>>>>
> >>>>> However, I do think it would make sense to have the userspace exit =
be a generic
> >>>>> exit type.  But hey, we already have the necessary ABI defined for =
that!  It's
> >>>>> just not used anywhere.
> >>>>>
> >>>>>    /* KVM_EXIT_HYPERCALL */
> >>>>>    struct {
> >>>>>            __u64 nr;
> >>>>>            __u64 args[6];
> >>>>>            __u64 ret;
> >>>>>            __u32 longmode;
> >>>>>            __u32 pad;
> >>>>>    } hypercall;
> >>>>>
> >>>>>
> >>>>>>> Userspace could also handle the MSR using MSR filters (would need=
 to
> >>>>>>> confirm that).  Then userspace could also be in control of the cp=
uid bit.
> >>>>> An MSR is not a great fit; it's x86 specific and limited to 64 bits=
 of data.
> >>>>> The data limitation could be fudged by shoving data into non-standa=
rd GPRs, but
> >>>>> that will result in truly heinous guest code, and extensibility iss=
ues.
> >>>>>
> >>>>> The data limitation is a moot point, because the x86-only thing is =
a deal
> >>>>> breaker.  arm64's pKVM work has a near-identical use case for a gue=
st to share
> >>>>> memory with a host.  I can't think of a clever way to avoid having =
to support
> >>>>> TDX's and SNP's hypervisor-agnostic variants, but we can at least n=
ot have
> >>>>> multiple KVM variants.
> >>>>>
> >>>> Potentially, there is another reason for in-kernel hypercall handlin=
g
> >>>> considering SEV-SNP. In case of SEV-SNP the RMP table tracks the sta=
te
> >>>> of each guest page, for instance pages in hypervisor state, i.e., pa=
ges
> >>>> with C=3D0 and pages in guest valid state with C=3D1.
> >>>>
> >>>> Now, there shouldn't be a need for page encryption status hypercalls=
 on
> >>>> SEV-SNP as KVM can track & reference guest page status directly usin=
g
> >>>> the RMP table.
> >>> Relying on the RMP table itself would require locking the RMP table f=
or an
> >>> extended duration, and walking the entire RMP to find shared pages wo=
uld be
> >>> very inefficient.
> >>>
> >>>> As KVM maintains the RMP table, therefore we will need SET/GET type =
of
> >>>> interfaces to provide the guest page encryption status to userspace.
> >>> Hrm, somehow I temporarily forgot about SNP and TDX adding their own =
hypercalls
> >>> for converting between shared and private.  And in the case of TDX, t=
he hypercall
> >>> can't be trusted, i.e. is just a hint, otherwise the guest could indu=
ce a #MC in
> >>> the host.
> >>>
> >>> But, the different guest behavior doesn't require KVM to maintain a l=
ist/tree,
> >>> e.g. adding a dedicated KVM_EXIT_* for notifying userspace of page en=
cryption
> >>> status changes would also suffice.
> >>>
> >>> Actually, that made me think of another argument against maintaining =
a list in
> >>> KVM: there's no way to notify userspace that a page's status has chan=
ged.
> >>> Userspace would need to query KVM to do GET_LIST after every GET_DIRT=
Y.
> >>> Obviously not a huge issue, but it does make migration slightly less =
efficient.
> >>>
> >>> On a related topic, there are fatal race conditions that will require=
 careful
> >>> coordination between guest and host, and will effectively be wired in=
to the ABI.
> >>> SNP and TDX don't suffer these issues because host awareness of statu=
s is atomic
> >>> with respect to the guest actually writing the page with the new encr=
yption
> >>> status.
> >>>
> >>> For SEV live migration...
> >>>
> >>> If the guest does the hypercall after writing the page, then the gues=
t is hosed
> >>> if it gets migrated while writing the page (scenario #1):
> >>>
> >>>  vCPU                 Userspace
> >>>  zero_bytes[0:N]
> >>>                       <transfers written bytes as private instead of =
shared>
> >>>                     <migrates vCPU>
> >>>  zero_bytes[N+1:4095]
> >>>  set_shared (dest)
> >>>  kaboom!
> >>
> >>
> >> Maybe I am missing something, this is not any different from a normal
> >> operation inside a guest. Making a page shared/private in the page tab=
le
> >> does not update the content of the page itself. In your above case, I
> >> assume zero_bytes[N+1:4095] are written by the destination VM. The
> >> memory region was private in the source VM page table, so, those write=
s
> >> will be performed encrypted. The destination VM later changed the memo=
ry
> >> to shared, but nobody wrote to the memory after it has been transition=
ed
> >> to the  shared, so a reader of the memory should get ciphertext and
> >> unless there was a write after the set_shared (dest).
> >>
> >>
> >>> If userspace does GET_DIRTY after GET_LIST, then the host would trans=
fer bad
> >>> data by consuming a stale list (scenario #2):
> >>>
> >>>  vCPU               Userspace
> >>>                     get_list (from KVM or internally)
> >>>  set_shared (src)
> >>>  zero_page (src)
> >>>                     get_dirty
> >>>                     <transfers private data instead of shared>
> >>>                     <migrates vCPU>
> >>>  kaboom!
> >>
> >>
> >> I don't remember how things are done in recent Ashish Qemu/KVM patches
> >> but in previous series, the get_dirty() happens before the querying th=
e
> >> encrypted state. There was some logic in VMM to resync the encrypted
> >> bitmap during the final migration stage and perform any additional dat=
a
> >> transfer since last sync.
> >>
> >>
> >>> If both guest and host order things to avoid #1 and #2, the host can =
still
> >>> migrate the wrong data (scenario #3):
> >>>
> >>>  vCPU               Userspace
> >>>  set_private
> >>>  zero_bytes[0:4096]
> >>>                     get_dirty
> >>>  set_shared (src)
> >>>                     get_list
> >>>                     <transfers as shared instead of private>
> >>>                   <migrates vCPU>
> >>>  set_private (dest)
> >>>  kaboom!
> >>
> >>
> >> Since there was no write to the memory after the set_shared (src), so
> >> the content of the page should not have changed. After the set_private
> >> (dest), the caller should be seeing the same content written by the
> >> zero_bytes[0:4096]
> > I think Sean was going for the situation where the VM has moved to the
> > destination, which would have changed the VEK. That way the guest
> > would be decrypting the old ciphertext with the new (wrong) key.
> >>
>
> But how can this happen, if a page is migrated as private , when it is re=
ceived it will be decrypted using the transport key TEK and then re-encrypt=
ed using the destination VM=E2=80=99s VEK on the destination VM.
>
If, as in scenario #3 above, the page is set to shared just before
being migrated. It would then be migrated in the clear, but be
interpreted on the target as encrypted (since, immediately
post-migration, the page is flipped to private without ever writing to
the page). This is not a scenario that is expected to work, as it
requires violating (currently unspoken?) invariants.

Thanks,
Steve

> Thanks,
> Ashish
>
> >>
> >>> Scenario #3 is unlikely, but plausible, e.g. if the guest bails from =
its
> >>> conversion flow for whatever reason, after making the initial hyperca=
ll.  Maybe
> >>> it goes without saying, but to address #3, the guest must consider ex=
isting data
> >>> as lost the instant it tells the host the page has been converted to =
a different
> >>> type.
> >>>
> >>>> For the above reason if we do in-kernel hypercall handling for page
> >>>> encryption status (which we probably won't require for SEV-SNP &
> >>>> correspondingly there will be no hypercall exiting),
> >>> As above, that doesn't preclude KVM from exiting to userspace on conv=
ersion.
> >>>
> >>>> then we can implement a standard GET/SET ioctl interface to get/set =
the guest
> >>>> page encryption status for userspace, which will work across SEV, SE=
V-ES and
> >>>> SEV-SNP.
