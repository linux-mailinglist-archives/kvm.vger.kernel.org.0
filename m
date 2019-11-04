Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22B96EDFB7
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2019 13:08:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728794AbfKDMIE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Nov 2019 07:08:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45470 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728671AbfKDMID (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Nov 2019 07:08:03 -0500
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com [209.85.221.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8158E4E8B8
        for <kvm@vger.kernel.org>; Mon,  4 Nov 2019 12:08:03 +0000 (UTC)
Received: by mail-wr1-f69.google.com with SMTP id w4so1883480wro.10
        for <kvm@vger.kernel.org>; Mon, 04 Nov 2019 04:08:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xfUJ5jYmM7xdhdl0A958lRoVsSGcVRgXLq6btCXnKV4=;
        b=BFV8yN5sbsXaSZgRxjsatJ/tyYRBbyj0Km7PJv+bx1c9P194QZSkIY3SnDzHsADtnZ
         AslmIA56OqT0QQ0ecCJWZsYOLeOvLtTx+syYqdSnwqvjE24QIv/XMtMy2jVyqyLL4+dJ
         HU5uHtpDdKgOuBcQKhQ84Gdq5YNImLdD2KfaHhJS4++Kczp6qWLE/mszeORwBi3xX9C4
         icvNuGfYQXgg+pOVXL56FQvuzNAJ1jEhxeMNoPHI5LxV+EX/25d9+YGapYpL4bHgVN5M
         VnqPCTPuUimXF0qnTfcAFLmTn6QI7oiRG9hI4NHAXxv/NrwAV765tnxde2yVFeCVXbHj
         Ri/A==
X-Gm-Message-State: APjAAAVZpAmCkPhbqQiCdLl86bRUC0hACOmrzDongi50hMnIxkhoTL3Y
        s1tvVFOCnk1eZbo8CBYAuPHQtTsJwOHuFOZ9b/pIXIpK7kNVpjIZt1nlqo/3f8dstd/svke+n5I
        WxSRTYWuhu+Y9
X-Received: by 2002:a1c:7c18:: with SMTP id x24mr14006532wmc.130.1572869282223;
        Mon, 04 Nov 2019 04:08:02 -0800 (PST)
X-Google-Smtp-Source: APXvYqzTcoPZCbgra6S8ndK62UnqKoJEwXmyVu9CqiHcwmsIft604DGJh6JnMczn3JqtLpXyna4+4A==
X-Received: by 2002:a1c:7c18:: with SMTP id x24mr14006506wmc.130.1572869281955;
        Mon, 04 Nov 2019 04:08:01 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:4051:461:136e:3f74? ([2001:b07:6468:f312:4051:461:136e:3f74])
        by smtp.gmail.com with ESMTPSA id t13sm10190744wrr.88.2019.11.04.04.08.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Nov 2019 04:08:01 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH v3 1/2] x86: realmode: save and restore %es
To:     Bill Wendling <morbo@google.com>, kvm@vger.kernel.org,
        jmattson@google.com
Cc:     thuth@redhat.com, alexandru.elisei@arm.com
References: <20191101203353.150049-1-morbo@google.com>
 <20191101203353.150049-2-morbo@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <119b3e09-1907-5c7f-7c47-753ce7effe23@redhat.com>
Date:   Mon, 4 Nov 2019 13:08:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191101203353.150049-2-morbo@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/11/19 21:33, Bill Wendling wrote:
> Some of the code test sequences (e.g. push_es) clobber ES. That causes
> trouble for future rep string instructions. So save and restore ES
> around the test code sequence in exec_in_big_real_mode.

You mean pop_es.  Applied with that change.

Paolo
