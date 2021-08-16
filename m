Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD6163ED916
	for <lists+kvm@lfdr.de>; Mon, 16 Aug 2021 16:43:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232306AbhHPOn4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Aug 2021 10:43:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:56153 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232377AbhHPOnn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Aug 2021 10:43:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629124975;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nBjVhanhpPaELALnY4MK4iEI3I/01CLjAVhRTcYSG4c=;
        b=IGJySoAqqTcFU38OzDHjpxbVWU1FYzAb8hyeSR2Z8O0y7jgD3n3gQxO3HeiioAyZFj4zr3
        SiyXuEYzgmv/bWAc66Jj+zQ3TUVKGjWU6+TJ5kEvhbfS/CXo4rQuXuEZX/tMGP3KbCFb3b
        FaIKorQgd6q2TwyMpAdwWfOf6Ewo6lc=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-434-QPPZmtg1Mfu2fKQahMsi1A-1; Mon, 16 Aug 2021 10:42:54 -0400
X-MC-Unique: QPPZmtg1Mfu2fKQahMsi1A-1
Received: by mail-ej1-f72.google.com with SMTP id v19-20020a170906b013b02905b2f1bbf8f3so4745901ejy.6
        for <kvm@vger.kernel.org>; Mon, 16 Aug 2021 07:42:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nBjVhanhpPaELALnY4MK4iEI3I/01CLjAVhRTcYSG4c=;
        b=JoqYnQRqzCV1GwGVq5oRJkPmmakZQ9KrRx28VcOYfiEgqFZKZxGzaVys2DZg6bO8JA
         fGzhyqeTIfz4t87uka2umdTiDmATAwbkDlwo7BFRnx07dwAqSXvqBMaub7yQH/MueKde
         fNfs0jkEOwj6UhRiJR1LFI8zN/JSLv/Qum/X0RZ9RhCwTer00uQuVzU4p7QQzrQY5W6O
         sfdjKLp4+wbm9dV4SQ2vmLa3gHZQwS9BFC/x27URcdZXs0DpVkNE1PE4xxO2DmO6aCc3
         mxxU50JeQbDK2N4AFQX8QBAcJLbp8eq3ma0x/uxjm1MRaHn0RHmAqsbG5MWRIlYIJVIx
         8NyA==
X-Gm-Message-State: AOAM533RS8H/zlCk38Wiqm3HdAAmn5kdGgu6irHgumokH9IbhC6+vbx7
        5qFAGcSBlgohPbHboXWzmEMmi60/wEwpX/9QDEKlgh6j0Y5z8bBCmxXeNnB53dlSGbRgn1tSX8D
        7xyxZpph/w9BB
X-Received: by 2002:a05:6402:160b:: with SMTP id f11mr20500837edv.22.1629124973285;
        Mon, 16 Aug 2021 07:42:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyVydQu2ZZL8nay/QmYJOkUzzTDg+npyKfPQRtLDYljZgpQCgh3DS2o+mWGh/B5NzSGHdyJSw==
X-Received: by 2002:a05:6402:160b:: with SMTP id f11mr20500826edv.22.1629124973158;
        Mon, 16 Aug 2021 07:42:53 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id s3sm3780822ejm.49.2021.08.16.07.42.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Aug 2021 07:42:52 -0700 (PDT)
Subject: Re: [PATCH 4.14.y] KVM: nSVM: always intercept VMLOAD/VMSAVE when
 nested (CVE-2021-3656)
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        stable@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>
References: <20210816140240.11399-8-pbonzini@redhat.com>
 <YRp1kmNV1i3Hds/U@kroah.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <9311b2e8-0107-89e1-26e6-95ba02d08479@redhat.com>
Date:   Mon, 16 Aug 2021 16:42:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YRp1kmNV1i3Hds/U@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/08/21 16:26, Greg KH wrote:
>>
>> [ upstream commit c7dfa4009965a9b2d7b329ee970eb8da0d32f0bc ]
> 
> This is not a commit in Linus's tree:(

Not yet, that was remarked further down in the message.  I sent the 
stable patches at the same time as the embargo lifted.

Paolo

