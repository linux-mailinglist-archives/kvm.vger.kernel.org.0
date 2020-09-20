Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76593271467
	for <lists+kvm@lfdr.de>; Sun, 20 Sep 2020 15:14:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726375AbgITNO0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 20 Sep 2020 09:14:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:58844 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726321AbgITNOZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 20 Sep 2020 09:14:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600607664;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kOcc4Mm2oqlSQPWb1TVwH0AOnNOAOKb7pgUNdANwl2s=;
        b=MpF/2dAcX/P4ibsLjC8FX65DBLxtIE5ke2gCEkiDhFMVVhr3TM19QoJjBPJ2GNVfTLpsxa
        Gz+vYwvAZLZonCGNFbLNi8Ro2GV2Sea1wKbtcb7dXqvulQ48pcLhLyTfV53NbTcJ8dPZxa
        IZLogfTsB66uUfcRcrUMWPwBSlcaYnA=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-272-bHQ4wIlkNDCuD4ExhaWL4A-1; Sun, 20 Sep 2020 09:14:22 -0400
X-MC-Unique: bHQ4wIlkNDCuD4ExhaWL4A-1
Received: by mail-wr1-f69.google.com with SMTP id f18so4582728wrv.19
        for <kvm@vger.kernel.org>; Sun, 20 Sep 2020 06:14:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kOcc4Mm2oqlSQPWb1TVwH0AOnNOAOKb7pgUNdANwl2s=;
        b=ZtBAXDAlZYG7ziuGbyQOQjFbnOT2e2wCe0eG6QaKL9rUI7IT2Xwr7MnZKD32CqEkOE
         RqqQIPw1jR2R25xhdtkP/QuyBodFATqFZ0YdvwpGxdnjbiVr4p7yZ+Va5YtXbzZLmEDd
         DBRE+Bm3v4zhZkxrThnLUUmoq0fgLFWv0RjvcAmRiGRFux3+ju2NJ/8W7P8wfS14egRN
         dMiatD1m7Rb4+0A+1PYDnYcwSr17voWlMETTFOTXUdjIVFx6A3bzQWYJWoLGlZ67DtR0
         8JHAdsBCfkZfDTL0MGA4ZTTr+1WCuxiW7DMqzk5/GDWa0QFg6FqGgUcs3qyYY+wHbCqw
         ackg==
X-Gm-Message-State: AOAM5300i7+rg4SlH2j+YpxmJWE6AUJ0RT6cjRhNPY+aY/hBsD8aGMN6
        9L3VzGSW1ZeTqHfE36JnFpgTRfha+xXbkOfTWSKNE1HRy/zogDnIW1f0iiwpqTCftPzpgcabW3y
        yjROmnXbGNbdv
X-Received: by 2002:a05:600c:2246:: with SMTP id a6mr26228059wmm.38.1600607661031;
        Sun, 20 Sep 2020 06:14:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwUeDeq9buCfzas3mmxEHjvbpu2G8sbbtzgUysbCbQ9WgOczZOBJK8Ha4p01Xx+NUyhoWq6og==
X-Received: by 2002:a05:600c:2246:: with SMTP id a6mr26228046wmm.38.1600607660832;
        Sun, 20 Sep 2020 06:14:20 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:458b:b280:cf0:4acf? ([2001:b07:6468:f312:458b:b280:cf0:4acf])
        by smtp.gmail.com with ESMTPSA id c16sm16544358wrx.31.2020.09.20.06.14.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Sep 2020 06:14:20 -0700 (PDT)
Subject: Re: [GIT PULL 0/1] KVM: s390: add documentation for
 KVM_CAP_S390_DIAG318 (5.9)
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Collin Walling <walling@linux.ibm.com>
References: <20200914082215.6143-1-borntraeger@de.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <ae636410-520c-2426-7269-67d78c4a8e7a@redhat.com>
Date:   Sun, 20 Sep 2020 15:14:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200914082215.6143-1-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/09/20 10:22, Christian Borntraeger wrote:
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git  tags/kvm-s390-master-5.9-1

Pulled, thanks.

Paolo

