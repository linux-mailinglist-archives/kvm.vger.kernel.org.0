Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 669362FDB62
	for <lists+kvm@lfdr.de>; Wed, 20 Jan 2021 22:25:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729373AbhATNoD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jan 2021 08:44:03 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29902 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727037AbhATMsK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 Jan 2021 07:48:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611146804;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=k+BpkyaexVwIjrPU5KJtj1aN8DF4ysQcoxRYEH3ORP4=;
        b=IzZGxz3Xew8YVRsBbi7GB+rRH+hKCmCrW0X2OOaZzTbfDWalgopYclBa2++zsMedh1SOZC
        Pvvp8HjeltNakS3D3lAxD8rOEQDjOGYtQfqv/PlBVAUesejv1UWMRLrE+Lz2CZIY/+R9IV
        MYQeCRjXsapxllePFH+Kx6S4MD/ES6o=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-201-INi-VBH4OZKyLKn8Qo41Hw-1; Wed, 20 Jan 2021 07:46:42 -0500
X-MC-Unique: INi-VBH4OZKyLKn8Qo41Hw-1
Received: by mail-ej1-f69.google.com with SMTP id le12so4356617ejb.13
        for <kvm@vger.kernel.org>; Wed, 20 Jan 2021 04:46:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=k+BpkyaexVwIjrPU5KJtj1aN8DF4ysQcoxRYEH3ORP4=;
        b=Dc6SU2SFYhXLg05WyDfIl/X5x6j3bJAezpPEJqvTPUV2dpZecsH0dg0LCr+g4tHek0
         B8kVB5TDMQCxVYKlPOvEucwEiGRNp9wJcjMlE4oWgP/2pqxPqt2XnWVIKzEawLIWPXYD
         qa+8M4Amc+ucWze5lX5kWU+v6yg3qe3MbuMDIS9cXKJXc8aL9bxnf4sY9f5TwYZ2+QLk
         jVl8e77HgDljrkLyZKFq5wGMH84JLiVTqErLououbsai0DNHfYz6hefg7GQYNjA2CaYa
         Gx/siKNjQFd8gbmCxiKXKeqxMWxACSkyAic7DltrY9dOJnZPO0AU3wxQq8dZYJQRqwqD
         c6Dg==
X-Gm-Message-State: AOAM533gK/5E+0uHHMqKYPglKwwadMFr/1mFasbWMFlagQdJaf0XEsgO
        B5AaeC15KoU8wTueIKK0JVC36KtHwP248jh+zoUr/AumLzdenHOLt8Cq2W+vGqKo8IfPbj9bkkg
        nsuwq7yKeUI2T
X-Received: by 2002:a05:6402:4c1:: with SMTP id n1mr7211727edw.66.1611146801382;
        Wed, 20 Jan 2021 04:46:41 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxkPjX3RI3ZL5PKU22ojPETwG7C2LrsncmQBlG68XGpAbggp2j5SnJeHKiIFIcUBxpyf7yXXA==
X-Received: by 2002:a05:6402:4c1:: with SMTP id n1mr7211712edw.66.1611146801268;
        Wed, 20 Jan 2021 04:46:41 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id b101sm1059835edf.49.2021.01.20.04.46.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Jan 2021 04:46:39 -0800 (PST)
Subject: Re: [kvm-unit-tests GIT PULL 00/11] s390x update
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, david@redhat.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, linux-s390@vger.kernel.org,
        imbrenda@linux.ibm.com
References: <20210120114158.104559-1-frankja@linux.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <3c78d5a9-338a-3a72-e49b-225d1d0883d0@redhat.com>
Date:   Wed, 20 Jan 2021 13:46:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210120114158.104559-1-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/01/21 12:41, Janosch Frank wrote:
>    https://gitlab.com/frankja/kvm-unit-tests.git  tags/s390x-2021-20-01

Pulled, thanks.

Paolo

