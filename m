Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7116B2EE99C
	for <lists+kvm@lfdr.de>; Fri,  8 Jan 2021 00:11:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728711AbhAGXLA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 18:11:00 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38554 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725944AbhAGXLA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 Jan 2021 18:11:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610060974;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jS5ydj15RUDwI0TqVNH2NZGdEGOPrdAAn5n/Kh60D+E=;
        b=GEutk18zD8tNXfaTMIpIQjNAkk/rA1wjcq9vFV80OajPWFTOiEWOhH3tQcOovQorU/s3D8
        L32UVUVumjBS0+T7GLU3CIHivK/u6lR+8bIKN7WwbYcwEzRTEBwvaHRx0OAF+6uBMEJKMd
        bk+SE7JhVt6z9foSMmUUfM7AcsdtswQ=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-329-yVN5-dcWMP2jHEaF4iWguQ-1; Thu, 07 Jan 2021 18:09:32 -0500
X-MC-Unique: yVN5-dcWMP2jHEaF4iWguQ-1
Received: by mail-wr1-f70.google.com with SMTP id v7so3251167wra.3
        for <kvm@vger.kernel.org>; Thu, 07 Jan 2021 15:09:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jS5ydj15RUDwI0TqVNH2NZGdEGOPrdAAn5n/Kh60D+E=;
        b=AF6CmhVWXlM7r3JZCBCUtBpHX4MXxSEpZR2oCX+6IhB5x7oShosQYHyfduwaGRy32k
         SndE7SwtwY97EPuNLFGd4KrrTtMWhGMEK5zijPQqW01ath7ZVH55Nj0CrlzsENzlNruK
         qEpXm6P/SFwetFo8n/4nODxnw+14bJN+B1jKOQdLLEe5KAknO8fR5ytvstJHjalDMGfR
         Mm0ykp7X+AP0Jt0p2OOkZgJxmitO9U0gSfH//6dRXccOymBN418lEk9lbKheAFRqDgUx
         h27FSYP08z58tV2NwuBLc2X3URqXsGvLTGTJ6RkxodDaak7O4AIbaBvxyqsrIerMK8ps
         QkSg==
X-Gm-Message-State: AOAM531B5MEMm/xQC2AwU2m7GjxddemUXBrpM7YI18jNcg0YaHx0PAKg
        JwZeFdFPqlKdfQLSedSRgDv82LmbDzcezQAg1umMGcxb9G4+DxQb2wq+mcbsxAgGyx1x4KMPwHY
        sqyfqdjyusmOF
X-Received: by 2002:a1c:741a:: with SMTP id p26mr632802wmc.47.1610060971559;
        Thu, 07 Jan 2021 15:09:31 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz1vCriFaS/d2WItmJer48+lx8LkEnY4JNrYOgKqDnQhiqtppnmfyDenoJYOL9XXWlswKroWw==
X-Received: by 2002:a1c:741a:: with SMTP id p26mr632789wmc.47.1610060971391;
        Thu, 07 Jan 2021 15:09:31 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id h15sm10070451wru.4.2021.01.07.15.09.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Jan 2021 15:09:30 -0800 (PST)
Subject: Re: [GIT PULL] KVM/arm64 fixes for 5.11, take #1
To:     Marc Zyngier <maz@kernel.org>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        David Brazdil <dbrazdil@google.com>,
        Eric Auger <eric.auger@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Qian Cai <qcai@redhat.com>,
        Shannon Zhao <shannon.zhao@linux.alibaba.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <20210107112101.2297944-1-maz@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <35b38baf-bd75-9054-76f8-15e642e05f55@redhat.com>
Date:   Fri, 8 Jan 2021 00:09:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20210107112101.2297944-1-maz@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/01/21 12:20, Marc Zyngier wrote:
>    git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.11-1

Looks like there are issues with the upstream changes brought in by this 
pull request.  Unless my bisection is quick tomorrow it may not make it 
into 5.11-rc3.  In any case, it's in my hands.

Paolo

