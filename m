Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 948A0337F3F
	for <lists+kvm@lfdr.de>; Thu, 11 Mar 2021 21:49:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230385AbhCKUtI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Mar 2021 15:49:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230231AbhCKUsw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Mar 2021 15:48:52 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 712BBC061574
        for <kvm@vger.kernel.org>; Thu, 11 Mar 2021 12:48:52 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id u20so23390343iot.9
        for <kvm@vger.kernel.org>; Thu, 11 Mar 2021 12:48:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=UQoFxXZvc3gQJU1fgokCDoSWR9gpWKlvLUH6Gip9gtU=;
        b=r6M+mRbw9lUP1km3/UVJd2JjOV0mWTtKM+KCu+8cQtUYSpi22yudBBx/KvOiVYMOTv
         WO3mIGiUG8dzqjAyYFZWLoptOF89EXFtOJaPhGC+HFULzsq/Klu32FcabkMf/1Jtrlwj
         GC2wIdtv1TBf0ovUfXpvnEDsbXL/c1H/QdissdQryZqw+dlGBjOj33ARMsQmJkevugiK
         r8LuuY3FTHJcXJGNdJftHuCjCAJMy6BSFHrHxNiVpUxc/DK5EZWqrWGGP1zDHdbBAwIJ
         H0ceYOX9tZYlgW43u8kCHXvqrJkw4EGWBumGnazNIeMl6qltAL1eHnAQMFQn18yGEBIY
         D6ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=UQoFxXZvc3gQJU1fgokCDoSWR9gpWKlvLUH6Gip9gtU=;
        b=Mysy9lVnOU2MMsG8f5e63U2dFhJs0CsnrpKOOOXuJtaczZ/1uM8Tkkbp3412ATrf/n
         cGEFqxQs22GrmYgLW+RGVKm1t661/09gbi8UEuVrS4FWQfnpw1OS1hNQDOaMdLoE8zTz
         ILf0q0I4dUeDfgYaOGW8S59i9FkDLcADSZTDVSjntN/j7EoVEbLxAnt0BcWQA4b1OrSZ
         dx7n/D+anDMTS4+1ACWdwUOhjpms+QF9Xq6KdsQ8wPmAv7I8JJvj+A3ZpEYXwQ4vSW4n
         maWgP96lcgLaryBKn4mI2oUxuvaZXhr0MRmB+Kk8zImKQGxednp11Gx6hhyTQ95zUPUL
         20lw==
X-Gm-Message-State: AOAM5327QgJyqrJ1qtMThXOaQCce5tSRAvPLXIG2dIFZTZbWbCqRRu3P
        VJGLVLg5ep69oaH0IRu5MOMreIHA3CMZFMMJ2nbEwg==
X-Google-Smtp-Source: ABdhPJwCZFYBLDdLOOaYii/M1WFGGx42V2HsWWvLddvOZM58Lx4ax6jIB5Wf6yZzVo5L1EmWDw27q0QqF7skThRqZDs=
X-Received: by 2002:a05:6638:1614:: with SMTP id x20mr5458728jas.19.1615495726921;
 Thu, 11 Mar 2021 12:48:46 -0800 (PST)
MIME-Version: 1.0
References: <YCxrV4u98ZQtInOE@google.com> <SN6PR12MB27672FF8358D122EDD8CC0188E859@SN6PR12MB2767.namprd12.prod.outlook.com>
 <20210224175122.GA19661@ashkalra_ubuntu_server> <YDaZacLqNQ4nK/Ex@google.com>
 <20210225202008.GA5208@ashkalra_ubuntu_server> <CABayD+cn5e3PR6NtSWLeM_qxs6hKWtjEx=aeKpy=WC2dzPdRLw@mail.gmail.com>
 <20210226140432.GB5950@ashkalra_ubuntu_server> <YDkzibkC7tAYbfFQ@google.com>
 <20210302145543.GA29994@ashkalra_ubuntu_server> <20210303185441.GA19944@willie-the-truck>
 <20210311181458.GA6650@ashkalra_ubuntu_server>
In-Reply-To: <20210311181458.GA6650@ashkalra_ubuntu_server>
From:   Steve Rutherford <srutherford@google.com>
Date:   Thu, 11 Mar 2021 12:48:07 -0800
Message-ID: <CABayD+cXH0oeV4-Ah3y6ThhNt3dhd0qDh6JmimjSz=EFjC+SYw@mail.gmail.com>
Subject: Re: [PATCH v10 10/16] KVM: x86: Introduce KVM_GET_SHARED_PAGES_LIST ioctl
To:     Ashish Kalra <ashish.kalra@amd.com>
Cc:     Will Deacon <will@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "venu.busireddy@oracle.com" <venu.busireddy@oracle.com>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        Quentin Perret <qperret@google.com>, maz@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 11, 2021 at 10:15 AM Ashish Kalra <ashish.kalra@amd.com> wrote:
>
> On Wed, Mar 03, 2021 at 06:54:41PM +0000, Will Deacon wrote:
> > [+Marc]
> >
> > On Tue, Mar 02, 2021 at 02:55:43PM +0000, Ashish Kalra wrote:
> > > On Fri, Feb 26, 2021 at 09:44:41AM -0800, Sean Christopherson wrote:
> > > > On Fri, Feb 26, 2021, Ashish Kalra wrote:
> > > > > On Thu, Feb 25, 2021 at 02:59:27PM -0800, Steve Rutherford wrote:
> > > > > > On Thu, Feb 25, 2021 at 12:20 PM Ashish Kalra <ashish.kalra@amd=
.com> wrote:
> > > > > > Thanks for grabbing the data!
> > > > > >
> > > > > > I am fine with both paths. Sean has stated an explicit desire f=
or
> > > > > > hypercall exiting, so I think that would be the current consens=
us.
> > > >
> > > > Yep, though it'd be good to get Paolo's input, too.
> > > >
> > > > > > If we want to do hypercall exiting, this should be in a follow-=
up
> > > > > > series where we implement something more generic, e.g. a hyperc=
all
> > > > > > exiting bitmap or hypercall exit list. If we are taking the hyp=
ercall
> > > > > > exit route, we can drop the kvm side of the hypercall.
> > > >
> > > > I don't think this is a good candidate for arbitrary hypercall inte=
rception.  Or
> > > > rather, I think hypercall interception should be an orthogonal impl=
ementation.
> > > >
> > > > The guest, including guest firmware, needs to be aware that the hyp=
ercall is
> > > > supported, and the ABI needs to be well-defined.  Relying on usersp=
ace VMMs to
> > > > implement a common ABI is an unnecessary risk.
> > > >
> > > > We could make KVM's default behavior be a nop, i.e. have KVM enforc=
e the ABI but
> > > > require further VMM intervention.  But, I just don't see the point,=
 it would
> > > > save only a few lines of code.  It would also limit what KVM could =
do in the
> > > > future, e.g. if KVM wanted to do its own bookkeeping _and_ exit to =
userspace,
> > > > then mandatory interception would essentially make it impossible fo=
r KVM to do
> > > > bookkeeping while still honoring the interception request.
> > > >
> > > > However, I do think it would make sense to have the userspace exit =
be a generic
> > > > exit type.  But hey, we already have the necessary ABI defined for =
that!  It's
> > > > just not used anywhere.
> > > >
> > > >   /* KVM_EXIT_HYPERCALL */
> > > >   struct {
> > > >           __u64 nr;
> > > >           __u64 args[6];
> > > >           __u64 ret;
> > > >           __u32 longmode;
> > > >           __u32 pad;
> > > >   } hypercall;
> > > >
> > > >
> > > > > > Userspace could also handle the MSR using MSR filters (would ne=
ed to
> > > > > > confirm that).  Then userspace could also be in control of the =
cpuid bit.
> > > >
> > > > An MSR is not a great fit; it's x86 specific and limited to 64 bits=
 of data.
> > > > The data limitation could be fudged by shoving data into non-standa=
rd GPRs, but
> > > > that will result in truly heinous guest code, and extensibility iss=
ues.
> > > >
> > > > The data limitation is a moot point, because the x86-only thing is =
a deal
> > > > breaker.  arm64's pKVM work has a near-identical use case for a gue=
st to share
> > > > memory with a host.  I can't think of a clever way to avoid having =
to support
> > > > TDX's and SNP's hypervisor-agnostic variants, but we can at least n=
ot have
> > > > multiple KVM variants.
> > >
> > > Looking at arm64's pKVM work, i see that it is a recently introduced =
RFC
> > > patch-set and probably relevant to arm64 nVHE hypervisor
> > > mode/implementation, and potentially makes sense as it adds guest
> > > memory protection as both host and guest kernels are running on the s=
ame
> > > privilege level ?
> > >
> > > Though i do see that the pKVM stuff adds two hypercalls, specifically=
 :
> > >
> > > pkvm_create_mappings() ( I assume this is for setting shared memory
> > > regions between host and guest) &
> > > pkvm_create_private_mappings().
> > >
> > > And the use-cases are quite similar to memory protection architectues
> > > use cases, for example, use with virtio devices, guest DMA I/O, etc.
> >
> > These hypercalls are both private to the host kernel communicating with
> > its hypervisor counterpart, so I don't think they're particularly
> > relevant here. As far as I can see, the more useful thing is to allow
> > the guest to communicate back to the host (and the VMM) that it has ope=
ned
> > up a memory window, perhaps for virtio rings or some other shared memor=
y.
> >
> > We hacked this up as a prototype in the past:
> >
> > https://nam11.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fand=
roid-kvm.googlesource.com%2Flinux%2F%2B%2Fd12a9e2c12a52cf7140d40cd9fa092dc8=
a85fac9%255E%2521%2F&amp;data=3D04%7C01%7Cashish.kalra%40amd.com%7C7ae6bbd9=
fa6442f9edcc08d8de75d14b%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C63750=
3944913839841%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiL=
CJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=3DJuon5nJ7BB6moTWYssRXOWrDOr=
YfZLmA%2BLrz3s12Ook%3D&amp;reserved=3D0
> >
> > but that's all arm64-specific and if we're solving the same problem as
> > you, then let's avoid arch-specific stuff if possible. The way in which
> > the guest discovers the interface will be arch-specific (we already hav=
e
> > a mechanism for that and some hypercalls are already allocated by specs
> > from Arm), but the interface back to the VMM and some (most?) of the ho=
st
> > handling could be shared.
> >
>
> I have started implementing a similar "hypercall to userspace"
> functionality for these DMA_SHARE/DMA_UNSHARE type of interfaces
> corresponding to SEV guest's add/remove shared regions on the x86 platfor=
m.
>
> This does not implement a generic hypercall exiting infrastructure,
> mainly extends the KVM hypercall support to return back to userspace
> specifically for add/remove shared region hypercalls and then re-uses
> the complete userspace I/O callback functionality to resume the guest
> after returning back from userspace handling of the hypercall.
>
> Looking fwd. to any comments/feedback/thoughts on the above.
Others have mentioned a lack of appetite for generic hypercall
intercepts, so this is the right approach.

Thanks,
Steve
