Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 679852314AC
	for <lists+kvm@lfdr.de>; Tue, 28 Jul 2020 23:34:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729461AbgG1VeI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jul 2020 17:34:08 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:39665 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729169AbgG1VeI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 28 Jul 2020 17:34:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595972047;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8O5PHiVEcRAHvPH64VDh7+CVIFmA6f8StYUcqt3EMHw=;
        b=NMHx3efIQfZM3kdU1r83aWLiD1++NJKTsT1dHAB7YlhpSQFjUkJQ9G0tOEeaIMVe+mqDVu
        8ZUiTUHk/3X1KJzVIFi3CP/RTpC2oxqqrp78n7YvL2vzK/ziMLn2nA3fkCwzWRE4jSQ/jO
        IyrB+LpTb2RQLpEuHrUsuOcr6xYeunk=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-37-QEz-qdyAMfSIa0ECNhJqfw-1; Tue, 28 Jul 2020 17:27:59 -0400
X-MC-Unique: QEz-qdyAMfSIa0ECNhJqfw-1
Received: by mail-wr1-f71.google.com with SMTP id 89so5751463wrr.15
        for <kvm@vger.kernel.org>; Tue, 28 Jul 2020 14:27:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8O5PHiVEcRAHvPH64VDh7+CVIFmA6f8StYUcqt3EMHw=;
        b=BgA5qCniaRVw6lhm4I289RFKnh9/PyPmZyR/gKupW+H2SeSDvRIS/LGveSGNvnCRSK
         dGgdE/13Z+wQHvrVlcI8b1aRoJGZgGCX2pBWtpa9Yws20lu850VXp+pX9ljDukIb49Th
         WxqlqfeIqFjjDf+A6WbjQmU/LD7ub8qF9RJPkYp9//W0kkiKTS3AF9uvKk7KL2joODP8
         pJHoqefzpmpmj31j2BD0e2TsVnBo7v73Fpi0xIb3ScSlo0PnKXyUR6j2c3Tq8EZhgLih
         NPXky5YCuuWEJM238up4uLbQXHKjbxkpmYz/nFmj+BxEywQz1iDQPSSCMMjcMLXgaL9B
         Qxyg==
X-Gm-Message-State: AOAM531bcFRIBEFu5dGHzJ/ZLPJjwgi6tgiAix4z50ffdqUxZ7LeO6Tw
        3VulTKEBY7LnyKrUMsdTz/GJii+TwOMoPu1oGRJY6PlxyzJY3uxVSpxSzUFsYVA7+4rq1tA1KuV
        exfYCTaov+bhk
X-Received: by 2002:a5d:4b0c:: with SMTP id v12mr26415284wrq.199.1595971678346;
        Tue, 28 Jul 2020 14:27:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzTfVwgH2m1LLwqkqpLZH1N6dOEZ5brd9Gr/q4Zm3lSulzH09MHS6Uix9uqEr4+pBl8CkjicQ==
X-Received: by 2002:a5d:4b0c:: with SMTP id v12mr26415275wrq.199.1595971678191;
        Tue, 28 Jul 2020 14:27:58 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.170.5])
        by smtp.gmail.com with ESMTPSA id h6sm157489wrv.40.2020.07.28.14.27.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jul 2020 14:27:57 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH] x86: svm: low CR3 bits are not MBZ
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Nadav Amit <namit@vmware.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <20200713043908.39605-1-namit@vmware.com>
 <ce87fd51-8e27-e5ff-3a90-06cddbf47636@oracle.com>
 <CCEF21D4-57C3-4843-9443-BE46501FFE8C@vmware.com>
 <abe9138a-6c61-22e1-f0a6-fcd5d06ef3f1@oracle.com>
 <6CD095D7-EF7F-49C2-98EF-F72D019817B2@vmware.com>
 <fe76d847-5106-bc09-e4cf-498fb51e5255@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <b77d197a-5f8c-d7b4-b2d6-bf5132a5fce4@redhat.com>
Date:   Tue, 28 Jul 2020 23:27:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <fe76d847-5106-bc09-e4cf-498fb51e5255@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/07/20 00:21, Krish Sadhukhan wrote:
> Paolo, Should I send a KVM patch to remove checks for those non-MBZ
> reserved bits ?

Yes, please.

Paolo

