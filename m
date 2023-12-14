Return-Path: <kvm+bounces-4521-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 48CD9813657
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 17:34:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7B4E11C20F13
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 16:34:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C20CE60B88;
	Thu, 14 Dec 2023 16:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gK+FOFhA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74261112
	for <kvm@vger.kernel.org>; Thu, 14 Dec 2023 08:34:15 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5d12853cb89so96477277b3.3
        for <kvm@vger.kernel.org>; Thu, 14 Dec 2023 08:34:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702571654; x=1703176454; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dgQLvbaqZFtHigUp/EtkoVbLXyham3BzC/5JXoUn+l4=;
        b=gK+FOFhAVl3PwgI3iS9BejvlarVDZflJr7QhpAqXpl72Ivi79wfMikHl+C4cyb2VPm
         Ax9PkOYgXCAdEGtWZhn612Q/igA/Pe3DOkCaoNxl18+h3MUxW1Ca63ybW6fkwGWy7HZL
         IALEV1cnD2NZ7gr/vwQ9AUJqfhkflZH2X1nrbo8NHYJiTKwfASA2/fgNtbVaN9dXO2rh
         wfwSHVyeDTT3LX8V16Kkift9w7vZyuGuW8pEvyqKNxbvaovg/InGNVfKS/1GZRA4LxOk
         HfK9qH2aU81RDeYaqq04IEkiwAM9uvizqK9GuIe4i1oBzZqeXY0ZlPWk1erMKSAdoSrl
         afQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702571654; x=1703176454;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dgQLvbaqZFtHigUp/EtkoVbLXyham3BzC/5JXoUn+l4=;
        b=Pp+7ABIyVgDmtjp+YX4+/9pk5wfx9bAg9cv4U09zsFGwguxRyxIh/uVzqu+l76gu75
         MVVeVhZ/MAyjalL35ltQqQ04ItHZQnw4tpo9bH3hywjKNI47Ykxe0Z2HcEhTBf6KdMyx
         L7KF8xdQ9R1vKr+dQg3vymmNEa5BVNlP/CTPzFdbTVk0UWLGkVTctflUdVCKNdy0/W4H
         ufCwn7R/o0hoaJ9fBoi/vzTXwZwoyMYYmNQH63z8jwVLYaAFdddL4HdyYllKaVl4ftQ1
         RqQms1VCneYY7ZHBEWF3FMWGQgjOKYt31IaKNVKWC/mnm6wSBv31XVPeXGiZw10dZyGV
         Fh3w==
X-Gm-Message-State: AOJu0Yxl/ThmXWB8ZvVMm1avHFbVqbvflGgy8opJ1LDQWiRXJ8ujLheM
	EpQRTu26gJDoiitV66LaX2B2VN68F5Y=
X-Google-Smtp-Source: AGHT+IGyuwsOx8hONotcvinU2TL/jZLWZjMBvbCKpQOSyVHlnfNq//5voUQE6Lf7ldDRVqln11okKSYy69w=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:c9c:b0:5e2:1d4d:bb78 with SMTP id
 cm28-20020a05690c0c9c00b005e21d4dbb78mr63397ywb.2.1702571654638; Thu, 14 Dec
 2023 08:34:14 -0800 (PST)
Date: Thu, 14 Dec 2023 16:34:12 +0000
In-Reply-To: <864jglbgsh.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231214001753.779022-1-seanjc@google.com> <864jglbgsh.wl-maz@kernel.org>
Message-ID: <ZXsuhF5Rns1H53zK@google.com>
Subject: Re: [ANNOUNCE / RFC] PUCK Future Topics
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, James Houghton <jthoughton@google.com>, 
	Peter Xu <peterx@redhat.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Isaku Yamahata <isaku.yamahata@linux.intel.com>, 
	David Matlack <dmatlack@google.com>, Yan Zhao <yan.y.zhao@intel.com>, 
	Michael Roth <michael.roth@amd.com>, Aaron Lewis <aaronlewis@google.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Michael Ellerman <mpe@ellerman.id.au>, 
	Nicholas Piggin <npiggin@gmail.com>, Huacai Chen <chenhuacai@kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Thu, Dec 14, 2023, Marc Zyngier wrote:
> On Thu, 14 Dec 2023 00:17:53 +0000,
> Sean Christopherson <seanjc@google.com> wrote:
> > 
> > Hi all!  There are a handful of PUCK topics that I want to get scheduled, and
> > would like your help/input in confirming attendance to ensure we reach critical
> > mass.
> > 
> > If you are on the Cc, please confirm that you are willing and able to attend
> > PUCK on the proposed/tentative date for any topics tagged with your name.  Or
> > if you simply don't want to attend, I suppose that's a valid answer too. :-)
> > 
> > If you are not on the Cc but want to ensure that you can be present for a given
> > topic, please speak up asap if you have a conflict.  I will do my best to
> > accomodate everyone's schedules, and the more warning I get the easier that will
> > be.
> > 
> > Note, the proposed schedule is largely arbitrary, I am not wedded to any
> > particular order.  The only known conflict at this time is the guest_memfd()
> > post-copy discussion can't land on Jan 10th.
> > 
> > Thanks!
> > 
> > 
> > 2024.01.03 - Post-copy for guest_memfd()
> >     Needs: David M, Paolo, Peter Xu, James, Oliver, Aaron
> > 
> > 2024.01.10 - Unified uAPI for protected VMs
> >     Needs: Paolo, Isaku, Mike R
> > 
> > 2024.01.17 - Memtypes for non-coherent MDA
> 
> DMA?

Doh, yes, DMA.

> >     Needs: Paolo, Yan, Oliver, Marc, more ARM folks?
> 
> Do we need anyone from the other architectures? I wouldn't be
> surprised if RISC-V was at least as picky as ARM on that front
> (assuming this really is about DMA and not something else).

Ah, yeah, probably.  I had just heard rumblings about ARM, and so ARM was on my
mind.  I added people from all the other flavors of KVM.

