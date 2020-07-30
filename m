Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79A9F233B16
	for <lists+kvm@lfdr.de>; Fri, 31 Jul 2020 00:05:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727110AbgG3WFT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jul 2020 18:05:19 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:30096 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726992AbgG3WFS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 30 Jul 2020 18:05:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596146717;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=oJ/zUlHfT5A+NLtSLe1dlRgtdgnGtLGnoQm9iotVwso=;
        b=NXC9UUXQ6y/QI+smZzOwftieV9PVWUmYSsh1BXEfoTju4vS4GYJE1XkCv09QnQqY4y7ZP9
        fowso2Atz5SqzblEli3WpVIzwGwKpdON4wj0FP7dyJC5xqtEAwPDm1WI9s51eYcwi77F8O
        Hu8WAf5k9MKYaWeL+yVwvzFsqh/0v3Y=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-452-81vimciaMJyve4BiAtqXVw-1; Thu, 30 Jul 2020 18:05:15 -0400
X-MC-Unique: 81vimciaMJyve4BiAtqXVw-1
Received: by mail-wr1-f71.google.com with SMTP id w7so6053812wre.11
        for <kvm@vger.kernel.org>; Thu, 30 Jul 2020 15:05:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=oJ/zUlHfT5A+NLtSLe1dlRgtdgnGtLGnoQm9iotVwso=;
        b=QS/JqLwRWYjqhYk4XMAkFlhgoTQf78EeIUhv3FCifZCgTlRNXTpHQE55NKJEXatJya
         uA+8F2CAZmHr6FzhywX5RZ/GZrzjpPpAFGvULdpZVOm3qGxgBAs1OM9cT8qJHZQmpVT1
         wBDGph08gQV/Wms9dKb3/M5WAGL5OSMD4Pixy10svDcYYzfqALN6F+hXMDN9JSve1ysu
         /U8zBClPwNzJePB4TXPaiSQ2DOVD666Va/hJKoijPGMy8G6H5cgBNM66GGlAG2JzGkf6
         4vQxdjUXQKoq24uWh9yTORbOgUunRkQxnYvDNSFyrbGgw4DgfzIJA4aXXDgUZ46+O/Gf
         0VlA==
X-Gm-Message-State: AOAM533ERrpHHdbBQ6PujyYLKssLIylESbG79k5oygBHZbQSDXRiXkFQ
        b2KZ59gk1gurzbRZWzZKjfEEc/zfRJ4MTGt9LjJJMozasbF3Q4jd2TlAMR/muHan58sJz+Grp0n
        mbqRp9ivgSXPo
X-Received: by 2002:adf:fe50:: with SMTP id m16mr671468wrs.27.1596146713903;
        Thu, 30 Jul 2020 15:05:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz06iGbNHobyuNnRmZwpnq3dsCyixj3JuCzizg92TrLqj/inDyTo8gQlK4uOcgHVBirteQIiA==
X-Received: by 2002:adf:fe50:: with SMTP id m16mr671460wrs.27.1596146713660;
        Thu, 30 Jul 2020 15:05:13 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:310b:68e5:c01a:3778? ([2001:b07:6468:f312:310b:68e5:c01a:3778])
        by smtp.gmail.com with ESMTPSA id p15sm10871525wrj.61.2020.07.30.15.05.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jul 2020 15:05:13 -0700 (PDT)
X-Mozilla-News-Host: news://lore.kernel.org:119
To:     KVM list <kvm@vger.kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: New repo for kvm-unit-tests
Cc:     Thomas Huth <thuth@redhat.com>
Message-ID: <7040f939-3f15-e56c-61dd-201ec46b6515@redhat.com>
Date:   Fri, 31 Jul 2020 00:05:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm-unit-tests now lives at its now home,
https://gitlab.com/kvm-unit-tests/kvm-unit-tests.  The kernel.org
repository has been retired.

Nothing else changes, we're still living in the 20th century for patch
submission and issue tracking.

Thanks Thomas for your work and your persistence!  I must admit it
really just works.

Paolo

