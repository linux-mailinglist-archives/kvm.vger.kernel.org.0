Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 125521A30FF
	for <lists+kvm@lfdr.de>; Thu,  9 Apr 2020 10:33:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726623AbgDIId1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Apr 2020 04:33:27 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:44152 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725970AbgDIId1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Apr 2020 04:33:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586421205;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/hdiPqOMseztn6iucQUoyCXnrLIQadtFsbDbeqao9UI=;
        b=EPBg4n/nMA2Dq/fpaf8BrqvksKQf7KMn9/AS/NlDPcRInkQ7v3YNv2lv0Hc1pUJCFdhHFF
        dVDrQNL6ffPsGOS1SdCk3pQz4EaslQdFFh/GIAIMsuwRuArxZ0QW6RYX7lwwHLyD57C3Hk
        pmhGz9/6ChCvJbgB+vhfLe0IJMM9YS8=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-172-X4zaEGwsN_qP7j6wh1c2Rw-1; Thu, 09 Apr 2020 04:33:23 -0400
X-MC-Unique: X4zaEGwsN_qP7j6wh1c2Rw-1
Received: by mail-wr1-f71.google.com with SMTP id e10so5991524wru.6
        for <kvm@vger.kernel.org>; Thu, 09 Apr 2020 01:33:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/hdiPqOMseztn6iucQUoyCXnrLIQadtFsbDbeqao9UI=;
        b=otyOYQvOcI5mGaLg+6WNYKz7Ism1a99tO316UM5gjwKFBeExOrg3/UjdjNjpVjQIa7
         AEzp4y3/L6r/5EI6q05YfjiTpRGiinMlaDwghzdbF3mmW/QRrayi8zFL5kwnogkvX8Hr
         9w5Cag1d8+QNTv9fXNwEmNWOufUX86K/068+Ha6Y29jaLT0ehGD3OP1w1xvLvuDzsHN7
         +TK7RURnlECkow9Man4713AVUp1+RaSCz9amimwBrJ9SZe6WLxhG1uj2Mzee6OnyEskj
         NUUgkRHCPG2THGkjthzEYI6jokW64voM1C3YHHeZLgeP1q59/lkcdobHYq3rtsjz04NR
         UOMQ==
X-Gm-Message-State: AGi0PubGFiAU/WLYW1MYGk5nZJ5GQmBCUI8TBqqB/YyMvgVjr5XtvQFS
        vMObichtXCUjf/bsz+iSYPBIi9e4ywcw5dS4zMxNoeR0Iz5gsE/nQeepPFtsM+nf2cnSUc/QtnB
        Qaq0W5cuF7Jk1
X-Received: by 2002:adf:fa51:: with SMTP id y17mr13734759wrr.358.1586421202020;
        Thu, 09 Apr 2020 01:33:22 -0700 (PDT)
X-Google-Smtp-Source: APiQypJjTHePjWlbae9G+mA2mBNjKNyRxaBwfu2E1EFEOBIbmMv0xE18brni6qYysVeR9fJcmoz0DA==
X-Received: by 2002:adf:fa51:: with SMTP id y17mr13734727wrr.358.1586421201718;
        Thu, 09 Apr 2020 01:33:21 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:bddb:697c:bea8:abc? ([2001:b07:6468:f312:bddb:697c:bea8:abc])
        by smtp.gmail.com with ESMTPSA id f5sm29791773wrj.95.2020.04.09.01.33.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Apr 2020 01:33:21 -0700 (PDT)
Subject: Re: Current mainline kernel FTBFS in KVM SEV
To:     Uros Bizjak <ubizjak@gmail.com>, kvm@vger.kernel.org
References: <CAFULd4adXFX+y6eCV0tVhg-iHZe+tAchJkuHMXe3ZWktzGk7Sw@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a2187cc0-cab6-78db-3e2d-6edaf647c882@redhat.com>
Date:   Thu, 9 Apr 2020 10:33:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <CAFULd4adXFX+y6eCV0tVhg-iHZe+tAchJkuHMXe3ZWktzGk7Sw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/04/20 10:20, Uros Bizjak wrote:
> Current mainline kernel fails to build (on Fedora 31) with:
> 
>   GEN     .version
>   CHK     include/generated/compile.h
>   LD      vmlinux.o
>   MODPOST vmlinux.o
>   MODINFO modules.builtin.modinfo
>   GEN     modules.builtin
>   LD      .tmp_vmlinux.btf
> ld: arch/x86/kvm/svm/sev.o: in function `sev_flush_asids':
> /hdd/uros/git/linux/arch/x86/kvm/svm/sev.c:48: undefined reference to
> `sev_guest_df_flush'
> ld: arch/x86/kvm/svm/sev.o: in function `sev_hardware_setup':
> /hdd/uros/git/linux/arch/x86/kvm/svm/sev.c:1146: undefined reference
> to `sev_platform_status'
>   BTF     .btf.vmlinux.bin.o

Strange, the functions are defined and exported with
CONFIG_CRYPTO_DEV_SP_PSP, which is "y" in your config.

Paolo

