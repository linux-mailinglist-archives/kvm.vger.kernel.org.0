Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4888D144082
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2020 16:29:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729061AbgAUP34 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jan 2020 10:29:56 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:31010 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727508AbgAUP3z (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Jan 2020 10:29:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579620594;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=drluyyJgvZU1MSvZk9nVX/INIds5bPQT7NFflzdSLzQ=;
        b=N8ykmREkLPcMC7F7vqMnLSroew9xhCBbuCGObElSM9wC85oR23MJnOoItEuLAjUCorXukn
        wqBNWJHQ04RPVF4orskkzEYZ0EO9naBRhCPI9qLdkBYvHgBVlEYgOwqrdqemb/Ekuccelj
        +FQKp7p7EDI3M1uNJvFK72K40raq/6k=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-307-KLO0wXPjMuivgZmhlvrcMQ-1; Tue, 21 Jan 2020 10:29:50 -0500
X-MC-Unique: KLO0wXPjMuivgZmhlvrcMQ-1
Received: by mail-wm1-f72.google.com with SMTP id 18so755943wmp.0
        for <kvm@vger.kernel.org>; Tue, 21 Jan 2020 07:29:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=drluyyJgvZU1MSvZk9nVX/INIds5bPQT7NFflzdSLzQ=;
        b=Oq3Z44yR3A0NnsoCr6CmUZgOtd6Dwvt9KReHicYmd5M1SwHTRZrbVXrvFkURk4YDnC
         tC8DjXnZoT+w9hdm0K9hmjLJRIWdMEvRu06wdVZEo9t3JRExTG7LY/JHuFwvexWAQKQ4
         5pnjc0mUt532io9kX5P67H982hhQvjAAjpUCUsDHg6PP65uSR05NmPPkAvu5RQS7qnwh
         5UBL3qdfy2iy+FYTtB0K2DHJKZM/0+uETtAEzljPK7Ol7p7sfWJReMrqD8JaXU1uZ1L4
         bdDZ4vLEebYBoW3PCZcHEZDCyWZ3xFeVw0RFSiAKJ2Iz2ZNb0ef++etAXQqU5UjROQux
         tbhA==
X-Gm-Message-State: APjAAAW39tgQ0KSaxn0ZUPfYGbn6ZXdoYPbq+X/mbA58xAwVvG57B92F
        Vxolihlz4aqGOhQcby5ccOCDSXp7oqvlwVQnTM49UtCSukgW94jS/nF+jaOSqGn31akmYJTgqDN
        64GKRGVOzfWkn
X-Received: by 2002:a7b:cb0a:: with SMTP id u10mr4986298wmj.165.1579620588915;
        Tue, 21 Jan 2020 07:29:48 -0800 (PST)
X-Google-Smtp-Source: APXvYqzv1AiZkeRHvYhkTqdyoDwaDda+xt9Gb+5IDcg8qw+ja8rw8ozohTnvztIc5tRcztih3xCz/Q==
X-Received: by 2002:a7b:cb0a:: with SMTP id u10mr4986279wmj.165.1579620588629;
        Tue, 21 Jan 2020 07:29:48 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:b509:fc01:ee8a:ca8a? ([2001:b07:6468:f312:b509:fc01:ee8a:ca8a])
        by smtp.gmail.com with ESMTPSA id p17sm52810460wrx.20.2020.01.21.07.29.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jan 2020 07:29:48 -0800 (PST)
Subject: Re: [PULL kvm-unit-tests 0/3] arm/arm64: Add prefetch abort test
To:     Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Cc:     alexandru.elisei@arm.com
References: <20200121131745.7199-1-drjones@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <0b3033da-f347-f393-b7b0-3482a52a9185@redhat.com>
Date:   Tue, 21 Jan 2020 16:29:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200121131745.7199-1-drjones@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/01/20 14:17, Andrew Jones wrote:
>   https://github.com/rhdrjones/kvm-unit-tests arm/queue

Pulled, thanks.  It may take until tomorrow before I push because I'm
testing 100-odd x86 patches. :)

Paolo

