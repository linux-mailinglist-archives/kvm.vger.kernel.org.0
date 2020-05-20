Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F3811DBA6A
	for <lists+kvm@lfdr.de>; Wed, 20 May 2020 19:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726845AbgETRAR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 May 2020 13:00:17 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:45488 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726510AbgETRAP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 May 2020 13:00:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589994012;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=X0s/clL5mjNTm9iTq4AW82jUcL/vW7HiRSQKjdhr2yY=;
        b=i2iXgm+BvsKAHdqtXzt4bEVlz5fOX95pQW3El8ZEjsK/ZdPXCWeXwOdFIXltvxL964Bn7y
        SLWXte7avvONzg/XYQBUPWI0MEIOEyj6aSQN6HOCOcBiEMtg7v9FV1AM38LdrzLmjFHZqq
        hKyzO/P6QaFsHXgWTnpWsWUGcVYGVx8=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-279-zMs2CJqnPQe5eDVFcAsmPw-1; Wed, 20 May 2020 13:00:06 -0400
X-MC-Unique: zMs2CJqnPQe5eDVFcAsmPw-1
Received: by mail-wr1-f71.google.com with SMTP id w9so1664365wrr.3
        for <kvm@vger.kernel.org>; Wed, 20 May 2020 10:00:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=X0s/clL5mjNTm9iTq4AW82jUcL/vW7HiRSQKjdhr2yY=;
        b=KpLnHYltuNuFWToM2GhPmaEHuVzw0OZsTzgyDjAeu6EaTNJu91UQ/tdNevir4sbRZ0
         +McnAEkipC3Uz4SZxaX1EtkAT6dsVm7I1TSukxqfowJpY9uyeg1By7G2BZzngKMOLpqN
         8xZqO9bkvfmLlZBAN7oGRZJ8fkmjedozSYVR0M0/H2hnG8W91NwPGxxv/VCauvSlVxZe
         Ii0daBSkx0RcPHpjYSlJZ2nWrinazylOfKUkRsyWOKUWFJoCaYmmd7LB5wE+8UpWgTon
         7+gVWTbcaQOXaxCYQHt36jWAXjxuNHui9NxdBXA4rXeh4ilOv76zxFbxSOFsHrw2ofQN
         qZig==
X-Gm-Message-State: AOAM531isOOGfhXWv4PgUaQ4XwGhutWmb0lsFYbtZyDk93T4VxCR9xVS
        2xVfeU0mwDOojPRPK+Lf+ftjZtNm07XXGeW8uHXrHiPuUtk32fi9RrmmHS3pxublCsb/GJNdnPh
        0c/z1jMtvkHR2
X-Received: by 2002:adf:f5c1:: with SMTP id k1mr4893040wrp.30.1589994005496;
        Wed, 20 May 2020 10:00:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwuFBue81XLEPWPGpg5C2PeSU5lxiWQNLEInF0QLqbrJcCGW+wbuSIRM+Mf8XQ0LvrbqxtoWg==
X-Received: by 2002:adf:f5c1:: with SMTP id k1mr4893027wrp.30.1589994005256;
        Wed, 20 May 2020 10:00:05 -0700 (PDT)
Received: from [192.168.178.58] ([151.30.94.134])
        by smtp.gmail.com with ESMTPSA id v131sm3947123wmb.27.2020.05.20.10.00.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 May 2020 10:00:04 -0700 (PDT)
Subject: Re: [PATCH 1/3] selftests: kvm: add a SVM version of state-test
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     oupton@google.com
References: <20200519180740.89884-1-pbonzini@redhat.com>
 <87y2pmsg8w.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <229dd02b-d8ab-0a81-63b5-0d24061ffe05@redhat.com>
Date:   Wed, 20 May 2020 19:00:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <87y2pmsg8w.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/05/20 18:50, Vitaly Kuznetsov wrote:
> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> 

This was sent by mistake, but thanks for the review anyway!

Paolo

