Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA252178D7
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 13:49:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727969AbfEHLty (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 07:49:54 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:40380 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727855AbfEHLty (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 May 2019 07:49:54 -0400
Received: by mail-wr1-f65.google.com with SMTP id h4so7542692wre.7
        for <kvm@vger.kernel.org>; Wed, 08 May 2019 04:49:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sRy1srPfJjIkh3DYfosMemnXUEoKdSSQQuJvgkHRhEQ=;
        b=qO4jezgMkJSlYlcr/RCeoRJ3dLb6lnGDTlp7IGkfXem6czaRA/Znm7le0+aOapnmbs
         TG/FwjpiglmnAgmt0ctV0RiqBrO2TgLozTKsRBQG6hZlXMztJW7zZPPzW6tpe23ptk3k
         M8WDiOjqkXDgZPGlE2p9jCPU4lsDteYV5xBDjfTk/o/IjqNLs1wGU5j3TyR3aKwuDuJ1
         2S18rj9UREke+pPPjpLHD9N4uVhLs4abw1Hsl6/kVB5f4kLVXhR8fMW44TYIcl+KF+X9
         aW9cC8NmVYKAMO1N9nh5SzEPFb3ikIyQRikTbUdZoEy3OgbpiT+LN7WGSR+zyW6aF7wR
         1Sng==
X-Gm-Message-State: APjAAAWssXqhx3TOXtz+HOiXnJkggqIfa86S+L1T1BIKZgsoA6xIJe4o
        eiKpV+YRpMx16zW08Rh08ArZ4QFonCf9QQ==
X-Google-Smtp-Source: APXvYqyeoQQP2TcLyPOcdLeTSDTPsJPOx7VXVbxRJwgmSxG6uuBkoSYkqmH0pfQQaYNL26zw99e5Xw==
X-Received: by 2002:adf:ebd0:: with SMTP id v16mr20565857wrn.175.1557316192718;
        Wed, 08 May 2019 04:49:52 -0700 (PDT)
Received: from [10.201.49.229] (nat-pool-mxp-u.redhat.com. [149.6.153.187])
        by smtp.gmail.com with ESMTPSA id w2sm11670352wrm.74.2019.05.08.04.49.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 May 2019 04:49:52 -0700 (PDT)
Subject: Re: [PATCH v2 3/3] KVM: Introduce KVM_CAP_MANUAL_DIRTY_LOG_PROTECT_2
To:     Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org
Cc:     Juan Quintela <quintela@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>
References: <20190508091547.11963-1-peterx@redhat.com>
 <20190508091547.11963-4-peterx@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <0075d39c-ed38-8289-062c-acde86869a4b@redhat.com>
Date:   Wed, 8 May 2019 13:49:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190508091547.11963-4-peterx@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/05/19 04:15, Peter Xu wrote:
> The previous KVM_CAP_MANUAL_DIRTY_LOG_PROTECT has some problem which
> blocks the correct usage from userspace.  Obsolete the old one and
> introduce a new capability bit for it.
> 
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---

I renamed it to KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2.  Also, this paragraph

+The old name of KVM_CAP_MANUAL_DIRTY_LOG_PROTECT_2 is
+KVM_CAP_MANUAL_DIRTY_LOG_PROTECT but it was obsolete now.

should be under the description of the capability, and perhaps can be
expanded like this:

+KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2 was previously available under the name
+KVM_CAP_MANUAL_DIRTY_LOG_PROTECT, but the implementation had bugs that make
+it hard or impossible to use it correctly.  The availability of
+KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2 signals that those bugs are fixed.
+Userspace should not try to use KVM_CAP_MANUAL_DIRTY_LOG_PROTECT.

No need to do anything on your part.

Paolo
