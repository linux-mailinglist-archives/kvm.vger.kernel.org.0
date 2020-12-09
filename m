Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 535DD2D3E3D
	for <lists+kvm@lfdr.de>; Wed,  9 Dec 2020 10:11:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728722AbgLIJJf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Dec 2020 04:09:35 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39981 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727899AbgLIJJf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 9 Dec 2020 04:09:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607504889;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KJwxuIPd4nlAbXQQmhJtbvMuCe0z2W0Y13mU4B8OPV4=;
        b=aSQon+ceUNshuC/9wuc1b5F/GXB0EeMcl9PQB5jqeHWA982TJyy7avNx79G0wXXhwEcj/N
        AOIpdFL84Wb8Zmqm3J+LQptUOKp5ibAZkzDrHNgusVDvJK+M3WXKMhVy/t3A0H9mLSEYE9
        PSKye/WwSQbO8MKBOWjSZwmV5rR2V4U=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-499-sMpbSN5AMJy3yRmHV2EUGw-1; Wed, 09 Dec 2020 04:08:07 -0500
X-MC-Unique: sMpbSN5AMJy3yRmHV2EUGw-1
Received: by mail-ej1-f72.google.com with SMTP id 3so344904ejw.13
        for <kvm@vger.kernel.org>; Wed, 09 Dec 2020 01:08:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KJwxuIPd4nlAbXQQmhJtbvMuCe0z2W0Y13mU4B8OPV4=;
        b=Y0alivYgYMOdIhUIolXtAOrlxkPmVUeFlpMMy6skNLMP3oTZBHevrM9HeGHW/nwpSH
         I7umefWAW80cNM5Bp8gkASWmxBXmptvxUGiWxrehX7YEVqr8cdk4usgUIoPztPBJ6Vlm
         z9y0lyWhW3cHNKyTCGiiW6urgE1oQ0a4dtbp79zMDlpLyTs1qDsNJcGdXcy+dujHtqvF
         YiCuEjf/5G6b2H70OCh4LWT1a5PDQ/0W3S2GC9aCbm+uRJ3ma/Aci7+/CXSsWclnU6sa
         U8q/ZvWrxPybnqmMPa9P723bi9aZyBk46Op3fR4Dbxy2KQr5ulEXu25HQQ4ApITUEqIm
         IrCA==
X-Gm-Message-State: AOAM530hSxppXNkakw3OAj+2Hl5+zGBLdqtc2AQ2zmHz4yav7/HOLsFM
        0rSBrH1Rh0lNSsLax52Q7he6oyA3Vv0riaO2Bi+DC7Yhp1+myXIDQjUY6psUqvja2LZuUGuyHjF
        gRZHyvVo2ssXG
X-Received: by 2002:a50:cfcf:: with SMTP id i15mr1084522edk.351.1607504885986;
        Wed, 09 Dec 2020 01:08:05 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwU5q85qW8vH9F5ycwt/U1/kcp/ss/VQNclhj/fFBciLk8UGvUfCYextx3u3uT92XhQv1qelQ==
X-Received: by 2002:a50:cfcf:: with SMTP id i15mr1084506edk.351.1607504885789;
        Wed, 09 Dec 2020 01:08:05 -0800 (PST)
Received: from [192.168.1.124] ([93.56.170.5])
        by smtp.gmail.com with ESMTPSA id v16sm915151eds.64.2020.12.09.01.08.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Dec 2020 01:08:04 -0800 (PST)
Subject: Re: [PATCH] tools/kvm_stat: Exempt time-based counters
To:     Stefan Raspl <raspl@linux.ibm.com>, kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com
References: <20201208210829.101324-1-raspl@linux.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <0c89c376-3cce-3d46-ca29-2b5ba1a3aab8@redhat.com>
Date:   Wed, 9 Dec 2020 10:08:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201208210829.101324-1-raspl@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/12/20 22:08, Stefan Raspl wrote:
> From: Stefan Raspl<raspl@de.ibm.com>
> 
> The new counters halt_poll_success_ns and halt_poll_fail_ns do not count
> events. Instead they provide a time, and mess up our statistics. Therefore,
> we should exclude them.

What is the issue exactly?  Do they mess up the formatting?

Paolo

> Removal is currently implemented with an exempt list. If more counters like
> these appear, we can think about a more general rule like excluding all
> fields name "*_ns", in case that's a standing convention.
> 
> Signed-off-by: Stefan Raspl<raspl@linux.ibm.com>
> Tested-and-reported-by: Christian Borntraeger<borntraeger@de.ibm.com>
> ---

