Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6E4218DEF0
	for <lists+kvm@lfdr.de>; Sat, 21 Mar 2020 10:01:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728294AbgCUJBS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 21 Mar 2020 05:01:18 -0400
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:34793 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728008AbgCUJBR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 21 Mar 2020 05:01:17 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.nyi.internal (Postfix) with ESMTP id F0B87580700;
        Sat, 21 Mar 2020 05:00:33 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Sat, 21 Mar 2020 05:00:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=ALmjW+HIyhOT5zUGzSO/D37QXo/
        rPihFOsRD5OGJ6Rg=; b=kEm5Ygo0FPZjRbTYocTFES8NPUlGElygVjugiSsRA3n
        vru8BJJ8tNWWA1aBC6MUE6AqY6wsLM3GXiyzB7/KcJWCNJ5lCCm/qDclG4dF8plq
        cNmoLuNTRlVe76ntEf+7CdsaxmJWLFFu4WB1muK4Vr1PWFPH+Sw4G81BFSLewgR+
        6JB2ll2rZZ1Fqd8jcerWqFgeMP0L+cILkgWYoMYlEPzb/cKy4uHV+HiCyK5HPTEC
        5gleYoVjpBsM4HR+qUC63mvzdIcTYERc3wPbzHAK/+CXXir9mMtzStZCZrUv+SGR
        zGf2i6w5hnLo5ZBYfBLQudzv3kzZiHDRw7PCNutkR2g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=ALmjW+
        HIyhOT5zUGzSO/D37QXo/rPihFOsRD5OGJ6Rg=; b=K5YF/0lqzw1nyUZssapERV
        MtAhWdygOUErp6IxIxf13m4mM6AQAI0DpHLEzGhWDooqcv+bylyHu3N/dfoZBDmj
        Zhfrekl8SxOJX0+8dtU+T0Wbcql66hw77sdHm8UNHjRryiGD8r1cejEtCeNkgqp+
        8J7AuVQyzAASfpsd28v/F88EJOVVbAsO14CtUDIMEI1dpYyrnFgJLaj5JcO1RXyl
        EWgNcRJ2tEoYpU4fr41gGrGUWIm7NOKL5/AxD6Rwh+KJGCzxwOvu/RDxUPGPIaav
        8wt9JoHbXEWCIyKhYjGIaTP75XGn2edAcZZOq3wZWwKHTLFCu02DsBBLMoLt2NfQ
        ==
X-ME-Sender: <xms:sNd1XkY87sJRpJfVaHD11KeSmppo5NtozC6kEyYOa0dy1nWhTxFCcw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudegvddguddvfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuffhomhgrihhnpehkvghrnhgvlh
    drohhrghenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgep
    tdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:sNd1XjoqGRzcgsGN119CZr0cGB46HCOMC49lNOQF0JG8ZsqhP4506w>
    <xmx:sNd1XigKcM5vELOC7gzLRXd1s7sdJlHk4LtlOZByhOU-60dxIiwOHw>
    <xmx:sNd1XtxT4PPqq4P-VuUfbGsOgmAJfzQuUeYekEUtM66_LEn-QrOdgw>
    <xmx:sdd1XoCMs5G_4X8iRTp-FQMpHB1bsG3DryCpfJp66UyBLjCju3N--A>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 62CB4328005A;
        Sat, 21 Mar 2020 05:00:32 -0400 (EDT)
Date:   Sat, 21 Mar 2020 10:00:30 +0100
From:   Greg KH <greg@kroah.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     David Rientjes <rientjes@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH] KVM: SVM: Issue WBINVD after deactivating an SEV guest
Message-ID: <20200321090030.GA884290@kroah.com>
References: <c8bf9087ca3711c5770bdeaafa3e45b717dc5ef4.1584720426.git.thomas.lendacky@amd.com>
 <alpine.DEB.2.21.2003201333510.205664@chino.kir.corp.google.com>
 <7b8d0c8c-d685-627b-676c-01c3d194fc82@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7b8d0c8c-d685-627b-676c-01c3d194fc82@amd.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 20, 2020 at 03:37:23PM -0500, Tom Lendacky wrote:
> On 3/20/20 3:34 PM, David Rientjes wrote:
> > On Fri, 20 Mar 2020, Tom Lendacky wrote:
> > 
> > > Currently, CLFLUSH is used to flush SEV guest memory before the guest is
> > > terminated (or a memory hotplug region is removed). However, CLFLUSH is
> > > not enough to ensure that SEV guest tagged data is flushed from the cache.
> > > 
> > > With 33af3a7ef9e6 ("KVM: SVM: Reduce WBINVD/DF_FLUSH invocations"), the
> > > original WBINVD was removed. This then exposed crashes at random times
> > > because of a cache flush race with a page that had both a hypervisor and
> > > a guest tag in the cache.
> > > 
> > > Restore the WBINVD when destroying an SEV guest and add a WBINVD to the
> > > svm_unregister_enc_region() function to ensure hotplug memory is flushed
> > > when removed. The DF_FLUSH can still be avoided at this point.
> > > 
> > > Fixes: 33af3a7ef9e6 ("KVM: SVM: Reduce WBINVD/DF_FLUSH invocations")
> > > Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> > 
> > Acked-by: David Rientjes <rientjes@google.com>
> > 
> > Should this be marked for stable?
> 
> The Fixes tag should take care of that.

No it does not.
Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

Yes, I have had to go around and clean up after maintainers who don't
seem to realize this, but for KVM patches I have been explicitly told to
NOT take any patch unless it has a cc: stable on it, due to issues that
have happened in the past.

So for this subsystem, what you suggested guaranteed it would NOT get
picked up, please do not do that.

greg k-h
