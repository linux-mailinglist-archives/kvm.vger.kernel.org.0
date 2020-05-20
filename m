Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99C711DC16C
	for <lists+kvm@lfdr.de>; Wed, 20 May 2020 23:34:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728425AbgETVd6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 May 2020 17:33:58 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:45621 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727839AbgETVd5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 May 2020 17:33:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590010436;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gB3w4R5SiN/csltSLBX+nnCVG1y+pWdmJzpsplak43k=;
        b=H5A0+1AmbFpjacNtuD78+I2k/NZXu0iFE4Yoq0YKxz+QNdWz4djUF1ypqEEz99hgn8YE+n
        4hWuedl2neVbY9xLuYbJlfRBIxZjCUMGih11uxBZEYeJ/hviKO009zX8rc0yNpv0iZB40t
        GqVDN0vz4TtHQnBENJkhwCULUZTiMiw=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-364-F4jqwPZDMD6z24vW6bAGcA-1; Wed, 20 May 2020 17:33:42 -0400
X-MC-Unique: F4jqwPZDMD6z24vW6bAGcA-1
Received: by mail-ed1-f72.google.com with SMTP id l33so1802550edl.23
        for <kvm@vger.kernel.org>; Wed, 20 May 2020 14:33:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gB3w4R5SiN/csltSLBX+nnCVG1y+pWdmJzpsplak43k=;
        b=TeJmJ55M3v2QqG8dKV8o/Mhf8vv/9DKP7wyPCJLh4SixdxDJTj2xCAScqNkkCJpXMm
         +jd+g9FgoF/u2kFjYYjXogErpq2PLZvE0HID2mO+GTFEkH0IJhxcjh+NARz6azTu5psZ
         SozjeMZ7DMnOZqRq7wX6obKnFuB6LCdb9xdOLNJ23c65y+g6umZCJ+b5bzmfrJzzkmIV
         OSo1l079Qh41l1ug5B4gcH4sM2Ivsv41YjrBn1Ce8yOMPstK+W+U6A2DjunNHAjkJcTO
         Mp/kHOXnDni+8UJVsjTzabD+Tht6TRAHpe0n3AsZ2arlRUjKPw+eAzilhKD/jMeHGzL2
         daeA==
X-Gm-Message-State: AOAM531i1TW3cuFSfO+3BI4Rxm38WbXuM8e6eDIg6LREWhnti9/toEaf
        3gX62bkAJkHLvQ393vALWpk0o7UT4+udo5oPmHvem2LZmXzwbH0RKef40y3QYZjKAyIdq4FFaiA
        /+VQScFLnGMde
X-Received: by 2002:a17:906:d215:: with SMTP id w21mr914756ejz.383.1590010419590;
        Wed, 20 May 2020 14:33:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzia0DvGV2lHMa6PwY6gsFkX7nDgcB6gFcJVQBCo+Mr3Y6LVk6Ks8id/A5l5WmsOsFCBc+UrQ==
X-Received: by 2002:a17:906:d215:: with SMTP id w21mr914743ejz.383.1590010419391;
        Wed, 20 May 2020 14:33:39 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:1c48:1dd8:fe63:e3da? ([2001:b07:6468:f312:1c48:1dd8:fe63:e3da])
        by smtp.gmail.com with ESMTPSA id dk11sm2694388edb.67.2020.05.20.14.33.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 May 2020 14:33:38 -0700 (PDT)
Subject: Re: [PATCH 22/24] uaccess: add memzero_user
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Christoph Hellwig <hch@infradead.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        vkuznets@redhat.com, Joerg Roedel <jroedel@suse.de>
References: <20200520172145.23284-1-pbonzini@redhat.com>
 <20200520172145.23284-23-pbonzini@redhat.com>
 <20200520204036.GA1335@infradead.org>
 <e2e23a99-f682-1556-dad0-408e78233eb6@redhat.com>
 <20200520212807.GD23230@ZenIV.linux.org.uk>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f08c1176-ed24-f578-5b81-360b1b28942c@redhat.com>
Date:   Wed, 20 May 2020 23:33:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200520212807.GD23230@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/05/20 23:28, Al Viro wrote:
> Unless I'm seriously misreading that patch, it could've been done as
> 
> static inline __must_check int memzero_user(void __user *addr, size_t size)
> {
> 	return clear_user(addr, n) ? -EFAULT : 0;
> }
> 
> What am I missing?

Ok, I have a serious tunnel vision problem.  Thanks very much Al.

Since I have your attention, would you take a look at
https://lore.kernel.org/lkml/20200421135119.30007-1-eesposit@redhat.com/
please?

Thanks,

Paolo

