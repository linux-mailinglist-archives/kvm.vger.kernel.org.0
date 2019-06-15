Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D13834706F
	for <lists+kvm@lfdr.de>; Sat, 15 Jun 2019 16:29:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726523AbfFOO24 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 15 Jun 2019 10:28:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56114 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725944AbfFOO24 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 15 Jun 2019 10:28:56 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3C37F308FBA0;
        Sat, 15 Jun 2019 14:28:56 +0000 (UTC)
Received: from maximlenovopc.usersys.redhat.com (unknown [10.35.206.31])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3D3565D9E2;
        Sat, 15 Jun 2019 14:28:49 +0000 (UTC)
Message-ID: <1d80a586342dfee0479db96a4457f7023b0260a9.camel@redhat.com>
Subject: Re: [RFC PATCH 8/8] svm: Allow AVIC with in-kernel irqchip mode
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
        "jsteckli@amazon.de" <jsteckli@amazon.de>,
        "sironi@amazon.de" <sironi@amazon.de>,
        "wawei@amazon.de" <wawei@amazon.de>
Date:   Sat, 15 Jun 2019 17:28:50 +0300
In-Reply-To: <d57a0843-061a-231a-9d50-d7e4d4d05d73@amd.com>
References: <20190204144128.9489-1-suravee.suthikulpanit@amd.com>
         <20190204144128.9489-9-suravee.suthikulpanit@amd.com>
         <20190205113404.5c5382e6@w520.home>
         <d57a0843-061a-231a-9d50-d7e4d4d05d73@amd.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Sat, 15 Jun 2019 14:28:56 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2019-02-06 at 11:20 +0000, Suthikulpanit, Suravee wrote:
> Alex,
> 
> On 2/6/19 1:34 AM, Alex Williamson wrote:
> > On Mon, 4 Feb 2019 14:42:32 +0000
> > "Suthikulpanit, Suravee"<Suravee.Suthikulpanit@amd.com>  wrote:
> > 
> > > Once the IRQ ack notifier for in-kernel PIT is no longer required
> > > and run-time AVIC activate/deactivate is supported, we can remove
> > > the kernel irqchip split mode requirement for AVIC.
> > > 
> > > Hence, remove the check for irqchip split mode when enabling AVIC.
> > 
> > Yay!  Could we also at this point make avic enabled by default or are
> > there remaining incompatibilities?  Thanks,
> 
> I'm looking into that next. I would need to ensure that enabling
> AVIC would not cause issues with other features.
> 
> Suravee

Hi!

Do you have any update on the state of this patch? 
I kind of stumbled on it accidently, while
trying to understand why AVIC is only enabled in the split irqchip mode.

Best regards,
	Maxim Levitsky

