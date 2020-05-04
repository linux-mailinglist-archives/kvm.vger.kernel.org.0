Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DD881C3F59
	for <lists+kvm@lfdr.de>; Mon,  4 May 2020 18:06:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729464AbgEDQF6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 May 2020 12:05:58 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:39721 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726551AbgEDQF6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 May 2020 12:05:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588608356;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/JVeck58huMvFA8/TA03p+8Qjm09cOK85lDBTKzlyGU=;
        b=agB51x/fADpyzZBsaGRIpLggkwpd0EaL4wJW6JzJsQqbVexuKI9rWysHnZSe3V82Mew9EV
        r/fQetHiZZL6JYFW4djS9CjmrSOZeadXWF41APO2wuD4IfoZ47NGUpdevH6ZdKEtDplTnK
        3XmX4ITxCGjw/UQBPH5XZkiBa9ok6hY=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-6-wpXjhwFZMniCKZ7Hp3DFmQ-1; Mon, 04 May 2020 12:05:54 -0400
X-MC-Unique: wpXjhwFZMniCKZ7Hp3DFmQ-1
Received: by mail-wr1-f71.google.com with SMTP id m5so11001342wru.15
        for <kvm@vger.kernel.org>; Mon, 04 May 2020 09:05:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/JVeck58huMvFA8/TA03p+8Qjm09cOK85lDBTKzlyGU=;
        b=AjfWyEixE9EeNOZJYi57euHMinK1D9IxHHyTbCKdET6gsw0OCMXFU8uOMZFTy1P1AJ
         ZYvAL788+Pj4nZGUTtXj2oeRjh4x4dr+eV9Hd2U9iHJqgDUMwGKEySWLHeJQ6maWhezU
         TCyy05Zph7o/6TbVUsxAVRbDW5L7SyVBRbHHmPYqHeO5jjqfJupGKV/jljlryGJgepOZ
         hjzHLWGqaNhrK+iX2Xc8J1hzMKB91oQgjOgh9LJMcNlKu8z92X2WTfqS9ED9p6JfpzOP
         H0qrTHxgnnMsSBloJVLzDmhedoGR/wxPDVHHo+qX9hbaDutuCvN3n7ZaceGeuYatWlgT
         p7nQ==
X-Gm-Message-State: AGi0PubaFWbbOkv3DoWiD+TzUihDdNmqIWC0+3wi5S87HgQx4EnGBilS
        p+iP5Zxa2e8OwI8cA+/3xfui9H/Fot57I5i32X4g3nEIbF847QtGeZrx7MflR+Df6mXFaTJmVYO
        SMdKuMAkW2O6C
X-Received: by 2002:a1c:4e16:: with SMTP id g22mr14716563wmh.157.1588608353288;
        Mon, 04 May 2020 09:05:53 -0700 (PDT)
X-Google-Smtp-Source: APiQypLl+FvW2SgRJan9DFKftDDZJg4qPN8I25yOxi5TFHxm89GNl7rDCkuf9ca4ZxOYRM+JtKXkfg==
X-Received: by 2002:a1c:4e16:: with SMTP id g22mr14716532wmh.157.1588608353041;
        Mon, 04 May 2020 09:05:53 -0700 (PDT)
Received: from [192.168.178.58] ([151.20.132.175])
        by smtp.gmail.com with ESMTPSA id n7sm1072795wrm.86.2020.05.04.09.05.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 May 2020 09:05:52 -0700 (PDT)
Subject: Re: [GIT PULL] KVM/arm fixes for 5.7, take #2
To:     Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>
Cc:     Andrew Jones <drjones@redhat.com>,
        Fangrui Song <maskray@google.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
References: <20200501101204.364798-1-maz@kernel.org>
 <20200504113051.GB1326@willie-the-truck>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <df78d984-6ce3-f887-52a9-a3e9164a6dee@redhat.com>
Date:   Mon, 4 May 2020 18:05:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200504113051.GB1326@willie-the-truck>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/05/20 13:30, Will Deacon wrote:
> I don't see this queued up in the kvm tree, which appears to have been
> sitting dormant for 10 days. Consequently, there are fixes sitting in
> limbo and we /still/ don't have a sensible base for arm64/kvm patches
> targetting 5.8.
> 
> Paolo -- how can I help get this stuff moving again? I'm more than happy
> to send this lot up to Linus via arm64 if you're busy atm. Please just
> let me know.

10 days is one week during which I could hardly work and the two
adjacent weekends.  So this is basically really bad timing in Marc's
first pull request, that he couldn't have anticipated.

I have pulled both trees now, so you can base 5.8 development on
kvm/master.  It will get to Linus in a couple days.

Paolo

