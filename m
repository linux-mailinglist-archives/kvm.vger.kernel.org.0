Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B31D53B390A
	for <lists+kvm@lfdr.de>; Fri, 25 Jun 2021 00:03:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232654AbhFXWGI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Jun 2021 18:06:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56904 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232591AbhFXWGG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 24 Jun 2021 18:06:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624572226;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xINwPHS+dfHZopNTm0uHfsDrjJ9951BYIaDBQCjjtec=;
        b=auOIuPrcQXdygrnnWKib6NnLx/OF3Aqwj7PkxWx7k2AWMGm9gzHdKeAjGy/UoczpwXcOdm
        Qnl97IDmnQRWimVcs8uRKjpmRGQPh4+lhrM8SRCExg9FThr7xAOxSojtOgMOLGid2jeSw1
        TpP5HbHA5ShpuxNWzaAwgnWHQpV7WIQ=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-499-JM79C3t8OiS_7V-JmjGeJQ-1; Thu, 24 Jun 2021 18:03:45 -0400
X-MC-Unique: JM79C3t8OiS_7V-JmjGeJQ-1
Received: by mail-wm1-f69.google.com with SMTP id w186-20020a1cdfc30000b02901ced88b501dso3411453wmg.2
        for <kvm@vger.kernel.org>; Thu, 24 Jun 2021 15:03:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xINwPHS+dfHZopNTm0uHfsDrjJ9951BYIaDBQCjjtec=;
        b=Ie3NdwAJC5Ag1M/CGr2eydJ7mIQsCPdNoVU2LKJEtwebsgYiKPj5jqzGsx9wGIP7Dh
         o8i3F8HwdfWyaxeYHJjME4WBEYOl4gjoQTgnp2Fiytoo+UpV3zCVNX7FykWSPPobtMDz
         quvgcu1GNv3qMSqVBTJbjuACfLFAgj4qthWTOEG6ufyMaQe+XQ/iK8dTRZDKxlIUx80K
         XX9nioifXf5+yzF0BcNFLWwSCmjkw1pd0vjJN8xf7ZqpD+eJZ/4eqDpgy2G1eMxwYnIm
         HeVSVmz7i3GdZqbg1YyGRiT/rALWjSY1/SLyDfG5SdMuA41YxRShJz+PwdmrQETc4qLe
         O8Xw==
X-Gm-Message-State: AOAM532UJhOgcYLL0C2rM9oOgMFoAVajv9XU2Z6qR432urRQeBcJcBOg
        /P56ier66OXRXyNhTN1SAUAF+sYtK7f4/eenoRy+XsG1y86d+7hZ+NiZh1CUIfHj/Bmg+8dPcJY
        +wpBnnqOqJ6aV
X-Received: by 2002:a5d:5259:: with SMTP id k25mr3794472wrc.331.1624572223964;
        Thu, 24 Jun 2021 15:03:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxCgqS09+IiM0mecZm6NBFzQwOQy0GTv6Ec+vOZajqOGoB1Q1LI/2+ZdB/c10FvH+UwrAQ+JQ==
X-Received: by 2002:a5d:5259:: with SMTP id k25mr3794455wrc.331.1624572223821;
        Thu, 24 Jun 2021 15:03:43 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id x25sm10368574wmj.23.2021.06.24.15.03.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Jun 2021 15:03:43 -0700 (PDT)
Subject: Re: linux-next: Signed-off-by missing for commits in the kvm tree
To:     Stephen Rothwell <sfr@canb.auug.org.au>, KVM <kvm@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
References: <20210625075849.3cff81da@canb.auug.org.au>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <9409cf8b-3d56-748f-64e6-6d1e42d62413@redhat.com>
Date:   Fri, 25 Jun 2021 00:03:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210625075849.3cff81da@canb.auug.org.au>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/06/21 23:58, Stephen Rothwell wrote:
> Hi all,
> 
> Commits
> 
>    df40a7ffa871 ("KVM: debugfs: Reuse binary stats descriptors")
>    01bb3b73038a ("KVM: selftests: Add selftest for KVM statistics data binary interface")
>    a4b86b00ad24 ("KVM: stats: Add documentation for binary statistics interface")
>    da28cb6cd042 ("KVM: stats: Support binary stats retrieval for a VCPU")
>    170a9e1294a7 ("KVM: stats: Support binary stats retrieval for a VM")
> 
> are missing a Signed-off-by from their committers.
> 

Fixed, thanks.  Still getting used to b4.

Paolo

