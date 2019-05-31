Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FD7831756
	for <lists+kvm@lfdr.de>; Sat,  1 Jun 2019 00:50:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726610AbfEaWuC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 May 2019 18:50:02 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:51017 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726541AbfEaWuC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 May 2019 18:50:02 -0400
Received: by mail-wm1-f67.google.com with SMTP id f204so2937930wme.0
        for <kvm@vger.kernel.org>; Fri, 31 May 2019 15:50:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=r6NgNqRhWaq191x9dCxnD4RlXHbkV9/EdBSxvhFP1Vw=;
        b=rYkGtyo/TD9Gh4KM6vQuxun2jKSQ35SdL/8jVFRkJoYGRzS4XSYFmX5srn5g/XgrtY
         W5zBFTx8d/vT5mwuPYEN4+QAOXsRrz9he07cWWha9131n2FXvqOA1utpoPnknVbBv8A9
         Lys+Iw80HAfVZSr8ar8PmDnW9iTW7o7KMPE/3ADAJBmKOvP6BbHcVYb8x98v+Zdap0rG
         CqSN+2w3+v23LeyOWHnD1JqPjxWn3SEY8wRE6sS+rxMoyKUI6of0fDOkAAhfU7BNiaWV
         c4JE/0OcJ8NZNfDhbVD/GX3ft6hhwzI7XV9WN3UTwEC1JzoC4sUOkNUCGWjN24NFZhrF
         nFSA==
X-Gm-Message-State: APjAAAVA1aOkCBq/uQ1tG9pkNALPNoTL8oQnep4NqH3UX8c8gX6lI1UC
        uzxuJeZ9IPLgBKaStLURqJRiaTD3sg5Zaw==
X-Google-Smtp-Source: APXvYqyM/XrwIroyNNYyH1E8zovWVkinoiBQN1Mfy1JzMUBi6FOH+Ym/XaVAOeu1WdbtomeeWlvF1Q==
X-Received: by 2002:a1c:7405:: with SMTP id p5mr7106342wmc.80.1559343000581;
        Fri, 31 May 2019 15:50:00 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:f910:d845:2bcd:e6c8? ([2001:b07:6468:f312:f910:d845:2bcd:e6c8])
        by smtp.gmail.com with ESMTPSA id u9sm15979696wme.48.2019.05.31.15.49.59
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 31 May 2019 15:50:00 -0700 (PDT)
Subject: Re: [GIT PULL 0/2] KVM: s390: fixes for 5.2-rc3
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Janosch Frank <frankja@linux.vnet.ibm.com>,
        David Hildenbrand <david@redhat.com>
References: <20190529125045.42935-1-borntraeger@de.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <7c70ab2b-4a3e-e8e6-8872-7d4f0f151306@redhat.com>
Date:   Sat, 1 Jun 2019 00:49:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190529125045.42935-1-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/05/19 14:50, Christian Borntraeger wrote:
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git  tags/kvm-s390-master-5.2-2

Pulled, thanks.

Paolo
