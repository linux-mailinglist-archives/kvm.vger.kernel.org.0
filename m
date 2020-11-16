Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E00E2B4F0B
	for <lists+kvm@lfdr.de>; Mon, 16 Nov 2020 19:20:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730105AbgKPSS0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 13:18:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24650 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730302AbgKPSS0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Nov 2020 13:18:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605550705;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tAHP+8zyc4EwCkB9PCeaZBFISgE3jVYS9b2gGcqczD8=;
        b=VSAounZFImjxXV6fNPrBGZpSEfyXjtHxf0Nm12AeOcj6QG7BQiu9jSyhXrPWC62WXS/kP9
        yHoBojD4Y+LiWtgPVYg7o8NFR+wfhZpMrb16HW8X+u3Ld+cxa2PhrSzMkFz+RZBxrhLnDD
        eUrbqqf3afAn6ebM2+h3PCyDFf4c4Dc=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-397-a4z0XsezMQaB_imMzCZOTA-1; Mon, 16 Nov 2020 13:18:23 -0500
X-MC-Unique: a4z0XsezMQaB_imMzCZOTA-1
Received: by mail-wr1-f69.google.com with SMTP id l5so11437522wrn.18
        for <kvm@vger.kernel.org>; Mon, 16 Nov 2020 10:18:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tAHP+8zyc4EwCkB9PCeaZBFISgE3jVYS9b2gGcqczD8=;
        b=R2C5fV8Ta879iO7OAYemarLte53JX0QRAPUyoB44mRgTDjAE+ox2DyoSHXL4AD2tPS
         kDrc2lh5hA1k5N4lQBU8JRD1p9tdqXcfUm84qM1ZnutICMsoOI7sGM8D6geN+6uA0C9z
         3nBOWmu+tBXfwFyTiouXMU/oRJedPO5yDzTAqDtJPHL2T7rw59YMBPKJTmMMykLm6kam
         28Nax52izdsfIxUJIEk6Sbv8hHX80P8vO2y0OSJZvyQe3wVHKNVMHGhVt1eB1WgBIWiF
         ST2qX0bo1Mix9mTb2Ev08TLB47FRwLspduaHhsTeIEXdnXP3UhWLUCGzH/HnT3lBWKwC
         f6Mw==
X-Gm-Message-State: AOAM5318qpBG77pS4S8rwm67Mh0dOeEeB85eZqixDLdMTOQyIl9V/yd1
        hJWecpHxNx+0fAjspXLFkk+a/a3wi1XIeILfaxga+X5b6lHZPFiIhE9+BwJQrXtO8GgVCI21klo
        Oyt/vpXQJSBJs
X-Received: by 2002:a1c:9949:: with SMTP id b70mr150566wme.85.1605550702211;
        Mon, 16 Nov 2020 10:18:22 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwO+z7hGfmJQS3UwtqvJGNRuNGNPfzM4u6SHMsc6XraQ5bpbjaI7svja2TpFhiq14tNRZ02Sg==
X-Received: by 2002:a1c:9949:: with SMTP id b70mr150549wme.85.1605550702047;
        Mon, 16 Nov 2020 10:18:22 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id s25sm144541wmh.16.2020.11.16.10.18.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Nov 2020 10:18:21 -0800 (PST)
Subject: Re: [GIT PULL 0/2] KVM: s390: Fixes for 5.10
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Collin Walling <walling@linux.ibm.com>
References: <20201116122033.382372-1-borntraeger@de.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f2ce11de-e2b4-206e-f6d5-0f21da73cd5a@redhat.com>
Date:   Mon, 16 Nov 2020 19:18:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201116122033.382372-1-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/11/20 13:20, Christian Borntraeger wrote:
>    git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git  tags/kvm-s390-master-5.10-1

Pulled, thanks.

Paolo

