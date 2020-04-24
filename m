Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2F6F1B8172
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 23:02:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726046AbgDXVCt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Apr 2020 17:02:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726032AbgDXVCt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Apr 2020 17:02:49 -0400
Received: from mail-vk1-xa42.google.com (mail-vk1-xa42.google.com [IPv6:2607:f8b0:4864:20::a42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2D35C09B049
        for <kvm@vger.kernel.org>; Fri, 24 Apr 2020 14:02:48 -0700 (PDT)
Received: by mail-vk1-xa42.google.com with SMTP id d6so1576815vko.4
        for <kvm@vger.kernel.org>; Fri, 24 Apr 2020 14:02:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=N+lekRCvAeIq1HnnVu1dMr0TEj8QJMC4PyRn69xzXA8=;
        b=Qg4TL8IyERbxZ4ldVherT7+8Xp22wDPat2HaRwguiuYRWkHmJToETRessf3QYBm1Ft
         wY1Jb6qdGOziULEpvY3RofC6ZToMQ7N8Nv5/ovg+dXabXbVgwsl690rEWl8vrgseQB8r
         o8iYO6aXpywZAV6M1ErBHT81hacRpcIkf6vBVbc1Bk/bslDfeJIYkrAcuhawRhxgy6sn
         dgNBoYanlSF7pjWMgIscOqeTapc0cBHQqrZ8yty7T2W0a+o4Zzps6JNC20hoV7RvFfE+
         yPYke/KYEbnIXqd0/8HhSZ+QW0e5GgLSl4rcyKyhyk21cEL531r5ANHAGM8yOCIIraGz
         FX+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=N+lekRCvAeIq1HnnVu1dMr0TEj8QJMC4PyRn69xzXA8=;
        b=K3D1sSQEYIWiXdwPhs/XQdR1Xvt9YVErp1lzIcELscNk6MHgZNYblC580q8igXk416
         jZtFrd9aDXVXDv4GabtLVr0hN87NICotAYsn/ei0ANuBlEIkZl8YGNhL4cJcOgPuNot+
         QSWnC+K7nfE+W95Cc7+zO01NM90i3NZhnNV4TKXGyYEpdKZG9K4iYfioXzwlos7Dk9Cj
         w9p41+QD2mqbuKHdyjonXjM0uk59KCu4dc3QlYyya3bfskorWGXBUnxJCdZVfBWhRY/P
         qXMaYDMxBhn845nrkjFY8V3wquHCPInYOM3Ma+F9UM1xsZJ+phyAxNw9lw7wKZFMbUcD
         E61w==
X-Gm-Message-State: AGi0PubgRctypJXN5mmU396b9/GP6xbyYOyuWuM8b8dNwLYcZh6qf5/L
        15x03wlOLU1vfhrbJ90Zr2kXpg==
X-Google-Smtp-Source: APiQypLW193+p+mWHTSAc87JCKYuoXneFfjRmShR5mwMzAfKp2W4ARyBRe8ZbJtLj/vq9CxiP/q1Zw==
X-Received: by 2002:a1f:1f52:: with SMTP id f79mr9655456vkf.19.1587762167144;
        Fri, 24 Apr 2020 14:02:47 -0700 (PDT)
Received: from google.com (25.173.196.35.bc.googleusercontent.com. [35.196.173.25])
        by smtp.gmail.com with ESMTPSA id t194sm1887798vkt.56.2020.04.24.14.02.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2020 14:02:46 -0700 (PDT)
Date:   Fri, 24 Apr 2020 21:02:42 +0000
From:   Oliver Upton <oupton@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        wei.huang2@amd.com, cavery@redhat.com, vkuznets@redhat.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH v2 00/22] KVM: Event fixes and cleanup
Message-ID: <20200424210242.GA80882@google.com>
References: <20200424172416.243870-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200424172416.243870-1-pbonzini@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo,

I've only received patches 1-9 for this series, could you resend? :)

--
Thanks,
Oliver
