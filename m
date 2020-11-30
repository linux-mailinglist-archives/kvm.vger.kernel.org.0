Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B21A2C8623
	for <lists+kvm@lfdr.de>; Mon, 30 Nov 2020 15:03:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727436AbgK3OCJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Nov 2020 09:02:09 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36744 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726779AbgK3OCJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Nov 2020 09:02:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606744842;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Z1V5TP+t4YgIIKSdanYDtXXCORZzAdrzBJD0xz3ZJJ4=;
        b=dNA3qqKiMp9svGhPcu4aKO439AsFhE+B7SZYEVyqF8KmCz/Z2EId7mHHJsNOj4X/f72mxu
        yLBvSdjb6jsn4SGhhWGw29Etzd084Vd2lc7iMbbk0AxPLey6CXYW13t2pVkviiC7P3TE7d
        TfmevBI0sQ5paw0phgmRYByPP9azhs8=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-227-R7EUJFzEOwuetxh9HsANXg-1; Mon, 30 Nov 2020 09:00:26 -0500
X-MC-Unique: R7EUJFzEOwuetxh9HsANXg-1
Received: by mail-ej1-f69.google.com with SMTP id n17so2046128eja.23
        for <kvm@vger.kernel.org>; Mon, 30 Nov 2020 06:00:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Z1V5TP+t4YgIIKSdanYDtXXCORZzAdrzBJD0xz3ZJJ4=;
        b=QWqCsJn5ThN8Fy22e+euKloZwGIic3UtEMAJjg+ZAEF5HudmaLLISMEpFLeaPMI1ov
         lKPAvHWfUIS9LRYdWZtzZoDaFnU7vVlFkLjXEnOLmUvYcVA8Z6S2oO0SXf76HJBii/Bo
         TpU2Fk0uT4OlZG7RAdlBP1hl+FqSeZvrkjHypEp5P3/UmdjBmwN086x+yrWB/6B4T7Mr
         5KH7Tgyoq9UxSjWEAq3r+FJ/43cYHSNJFoc+ScUzynn1sLZHRNLfxQq5taIHVKHWrcQq
         /A+n2zdsPuDXw5TR5MVTYg6l7EM4wqWX+L+8quaJmhA6Asx53XCHFRJl9FZ3okFudL9N
         hxng==
X-Gm-Message-State: AOAM532PsXaHWz/+cK1MBKD0xGBiON9LQEXMbD3hS8Je4vysXiXb/FLN
        bHgp+OLIKxaFe5cwYxx4b3Hxz4m5BC7a897jZclaEoOo8jK+iWLcngl9ZYCaMCvhPNoe8mtm6GD
        csKhbf15m6Sco
X-Received: by 2002:a17:906:e093:: with SMTP id gh19mr16467737ejb.510.1606744817031;
        Mon, 30 Nov 2020 06:00:17 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxPMhCAxuB2B/TcTZz4LyxRjBTd2O6WcbKZeK0qo3nFya2kmMSturj18lyD86gg2TrlnvR3iQ==
X-Received: by 2002:a17:906:e093:: with SMTP id gh19mr16467362ejb.510.1606744815303;
        Mon, 30 Nov 2020 06:00:15 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id f25sm8943114edr.53.2020.11.30.06.00.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Nov 2020 06:00:14 -0800 (PST)
Subject: Re: [PATCH AUTOSEL 5.9 22/33] vhost scsi: add lun parser helper
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        Mike Christie <michael.christie@oracle.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org
References: <20201125153550.810101-22-sashal@kernel.org>
 <25cd0d64-bffc-9506-c148-11583fed897c@redhat.com>
 <20201125180102.GL643756@sasha-vm>
 <9670064e-793f-561e-b032-75b1ab5c9096@redhat.com>
 <20201129041314.GO643756@sasha-vm>
 <7a4c3d84-8ff7-abd9-7340-3a6d7c65cfa7@redhat.com>
 <20201129210650.GP643756@sasha-vm>
 <e499986d-ade5-23bd-7a04-fa5eb3f15a56@redhat.com>
 <X8TzeoIlR3G5awC6@kroah.com>
 <17481d8c-c19d-69e3-653d-63a9efec2591@redhat.com>
 <X8T6RWHOhgxW3tRK@kroah.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8809319f-7c5b-1e85-f77c-bbc3f22951e4@redhat.com>
Date:   Mon, 30 Nov 2020 15:00:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <X8T6RWHOhgxW3tRK@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/11/20 14:57, Greg KH wrote:
>> Every patch should be "fixing a real issue"---even a new feature.  But the
>> larger the patch, the more the submitters and maintainers should be trusted
>> rather than a bot.  The line between feature and bugfix_sometimes_  is
>> blurry, I would say that in this case it's not, and it makes me question how
>> the bot decided that this patch would be acceptable for stable (which AFAIK
>> is not something that can be answered).
> I thought that earlier Sasha said that this patch was needed as a
> prerequisite patch for a later fix, right?  If not, sorry, I've lost the
> train of thought in this thread...

Yeah---sorry I am replying to 22/33 but referring to 23/33, which is the 
one that in my opinion should not be blindly accepted for stable kernels 
without the agreement of the submitter or maintainer.

Paolo

