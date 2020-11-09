Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 229712AB3D9
	for <lists+kvm@lfdr.de>; Mon,  9 Nov 2020 10:43:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729154AbgKIJns (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Nov 2020 04:43:48 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34777 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727959AbgKIJnr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 9 Nov 2020 04:43:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604915026;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Dyt2RPIryDUpKY3QdBsRG/hsGgQZ+lKraaiM8QPeOSM=;
        b=DkGtZNWKVcTCVOq7+841ciVp71wMlphDAcCsPQ4c/HjSAOGyEC1AnSqvKQwHU0Ztqt/t2n
        DgMVYqe/NvbqvoUnupW6RHguNYSRwGZ1FWWl3mQXPfyJyxVYn53s5zLQ+0BQN8K02+26TQ
        CzKMZMmLr50nRMOZ6LpULfW1gOZNmc0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-91-Y42i76i3NDWOFMA1uA47NQ-1; Mon, 09 Nov 2020 04:43:45 -0500
X-MC-Unique: Y42i76i3NDWOFMA1uA47NQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D5E00801F98;
        Mon,  9 Nov 2020 09:43:43 +0000 (UTC)
Received: from starship (unknown [10.35.206.112])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B217C5D98A;
        Mon,  9 Nov 2020 09:43:41 +0000 (UTC)
Message-ID: <a6a6e3936bd130e16ec341628e504adf9d3cb477.camel@redhat.com>
Subject: Re: linux-next: Fixes tag needs some work in the kvm-fixes tree
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Date:   Mon, 09 Nov 2020 11:43:39 +0200
In-Reply-To: <20201109081444.6f15fca2@canb.auug.org.au>
References: <20201109081444.6f15fca2@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2020-11-09 at 08:14 +1100, Stephen Rothwell wrote:
> Hi all,
> 
> In commit
> 
>   cc4cb017678a ("KVM: x86: use positive error values for msr emulation that causes #GP")
> 
> Fixes tag
> 
>   Fixes: 291f35fb2c1d1 ("KVM: x86: report negative values from wrmsr emulation to userspace")
> 
> has these problem(s):
> 
>   - Target SHA1 does not exist
> 
> Maybe you meant
> 
> Fixes: 7dffecaf4eab ("KVM: x86: report negative values from wrmsr emulation to userspace")
> 

This is true. Looks like one of my local commits slipped though.
Next time I'll check this more carefully.

Can this be fixed or is it too late?

Best regards,
	Maxim Levitsky

