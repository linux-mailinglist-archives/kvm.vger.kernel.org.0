Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8135A3DDAAE
	for <lists+kvm@lfdr.de>; Mon,  2 Aug 2021 16:19:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235851AbhHBOTi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Aug 2021 10:19:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48337 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233985AbhHBOSl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 2 Aug 2021 10:18:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627913911;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nKPiZnkfFpbECWjkGx+yjrL2AFZtgClsiNR+joepZ9w=;
        b=BzsF4GpIXng8o5qhrnFr8l4YQq7GbU2f4P6Ii2dOcskr0xcJK2NhYdn+8/cQgJ2NU8oidf
        SODr2LY3qiVujGr27kh0fP3I5A7GQ5XMq0geJyrAsMMjKQrBXHYAcL2o7N7KGVhkxZB9XA
        kH8+v9vLJr6eDNpbnZxvIxBUyWU4I5E=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-393-Piza9fUyOE2m31mSfHzpYw-1; Mon, 02 Aug 2021 10:18:30 -0400
X-MC-Unique: Piza9fUyOE2m31mSfHzpYw-1
Received: by mail-wr1-f69.google.com with SMTP id n6-20020a5d67c60000b0290153b1422916so6536818wrw.2
        for <kvm@vger.kernel.org>; Mon, 02 Aug 2021 07:18:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nKPiZnkfFpbECWjkGx+yjrL2AFZtgClsiNR+joepZ9w=;
        b=KuDwcYc4ffJYXZC1ywPFU+xLLXJZ/oiF2YhjWCZVr78qUrzktv1wHIphzPxEDJPdpB
         bP416JejzUrAVG2y7Jo95+FpfsfinQxUm46RUC/vpaXdACSbAL/DW8Jj97DlwJ2psYne
         nfvRTxIkc+9x5IqjTcH8tAhFMvVtIGriJ74MSlLG7iu78lUKl+9iXaZ8fFMQFofYAPf4
         9gRzL+xZlYcfgwqXsuiEF3oiO5bIThs+IOJ1WRTLFQrkDJ2wC6mKvQwfpsRQKlwks9bO
         20sLe7JNxULXeWQcZl/HZMXXe26cFexSabQiiuD2J6Phj16zRTfjFOXlNTfl21hkPZ6b
         QfzQ==
X-Gm-Message-State: AOAM533KDOY8sKlcsdnAAXjB7C5Zvwu6IZMUj4ddBNR1G3gB3wW6vAGd
        dwk3ua2MALNNe7FRs22DlWMMu7AX2RJ/n9l2Yq4zJsFUvkLjqlVahK5GWkSVmyy+GXIdT/uNdJy
        29TKz0YHUSKug
X-Received: by 2002:a1c:6a03:: with SMTP id f3mr13683489wmc.135.1627913908998;
        Mon, 02 Aug 2021 07:18:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyhOagyk2D3xRIPdwKYTWPqazPtF2Oxv55W3OurVPAxPkVM/sQetoo3kUnxxhrsPWigtkK3EQ==
X-Received: by 2002:a1c:6a03:: with SMTP id f3mr13683469wmc.135.1627913908815;
        Mon, 02 Aug 2021 07:18:28 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id v12sm11386375wrq.59.2021.08.02.07.18.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Aug 2021 07:18:28 -0700 (PDT)
Subject: Re: [PATCH] KVM: nVMX: nSVM: Show guest mode in kvm_{entry,exit}
 tracepoints
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>, kvm@vger.kernel.org
Cc:     jmattson@google.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, joro@8bytes.org
References: <20210621204345.124480-1-krish.sadhukhan@oracle.com>
 <20210621204345.124480-2-krish.sadhukhan@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <ac5d0cb7-9955-0482-33ee-cf06bb55db7a@redhat.com>
Date:   Mon, 2 Aug 2021 16:18:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210621204345.124480-2-krish.sadhukhan@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/06/21 22:43, Krish Sadhukhan wrote:
> With this patch KVM entry and exit tracepoints will
> show "guest_mode = 0" if it is a guest and "guest_mode = 1" if it is a
> nested guest.

What about adding a "(nested)" suffix for L2, and nothing for L1?

Paolo

