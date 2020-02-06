Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9000E1548FC
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 17:22:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727606AbgBFQWA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Feb 2020 11:22:00 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:58934 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727514AbgBFQWA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Feb 2020 11:22:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:
        From:Date:Sender:Reply-To:Content-ID:Content-Description;
        bh=Mqf4DktaGBMsaZFAiQnQOroz3SR1zlxAOUelwVv3tVU=; b=mArUrAhBeybhMJno8cHRbjqfQB
        bRDfliZO/WT5dvULl2FSAulaWTDe/KeCbivBMUe+N5L9jc6rKV6yvCCYiEu787imMP+wUO63C4zWd
        dpOuVtuf98CCt5y4oXxaR4wtbSC73W5Ddp9oU2dTANYwG4nfC60cK1EAZczDSajjru4UlLd6cq5p+
        f+1P6lq/CmRHaOwgAv4Xt++gPvTb2gfxGgzzi40Bbmuqr4/JHVHQsONjHkezGWfpiW4a9VIsb0DD/
        Ofbm2cHu8wQbLFtEjeDPC/Ro5gJQcxO5/f8Dw+KF6xjAKUx+6jeExyZ0oEho2ib1Ut6zL0qUWTVRm
        viFFB3gw==;
Received: from [179.95.15.160] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1izjud-00057R-2N; Thu, 06 Feb 2020 16:21:56 +0000
Date:   Thu, 6 Feb 2020 17:21:36 +0100
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-doc@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Richard Weinberger <richard@nod.at>,
        Jeff Dike <jdike@addtoit.com>, kvm@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>, linux-um@lists.infradead.org
Subject: Re: [PATCH v2 00/27] docs: virt: manually convert text documents to
 ReST format
Message-ID: <20200206172136.2fd36abd@kernel.org>
In-Reply-To: <20200206171738.75f374da.cohuck@redhat.com>
References: <cover.1581000481.git.mchehab+huawei@kernel.org>
        <20200206171738.75f374da.cohuck@redhat.com>
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Em Thu, 6 Feb 2020 17:17:38 +0100
Cornelia Huck <cohuck@redhat.com> escreveu:

> On Thu,  6 Feb 2020 15:49:57 +0100
> Mauro Carvalho Chehab <mchehab+huawei@kernel.org> wrote:
> 
> > Manually convert the documentation under Documentation/virt to ReST,
> > minimizing the usage of uneeded markups and preserving the documentation
> > writer's style.  
> 
> While you're at it: Would it make sense to convert and move the lone
> file under Documentation/virtual/ that survived 2f5947dfcaec
> ("Documentation: move Documentation/virtual to Documentation/virt")
> (probably due to a conflict) under virt/ as well?

Sure. Will do at the next version of this series.

Regards,
Mauro
