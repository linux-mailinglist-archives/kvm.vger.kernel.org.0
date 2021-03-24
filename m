Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 090EE347DD8
	for <lists+kvm@lfdr.de>; Wed, 24 Mar 2021 17:39:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236432AbhCXQi7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Mar 2021 12:38:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40765 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236407AbhCXQiz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 24 Mar 2021 12:38:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616603934;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZF8HRT5IrNOvQL6Pz8F1OKHc43im4d3pUJ9N+IN8ny4=;
        b=cgVu6POyb85osK1u0+jZFWG6m9vweX6xn3Y1B2lI+1OeEzt7AdZs9UyovVh4P/adgNNUpP
        ZA5/9G3xZDbZ18pWOMj6gdSGhM8+hbnu6jZBygQwdjp56vofSdzLlHOg4JCKZ6PCnGkdkx
        whjwEPQPjVstrbYIadB75u+zkqR0Dqg=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-4-Id5rbN_jOn69N275__ZV6A-1; Wed, 24 Mar 2021 12:38:47 -0400
X-MC-Unique: Id5rbN_jOn69N275__ZV6A-1
Received: by mail-wr1-f71.google.com with SMTP id s10so1329323wre.0
        for <kvm@vger.kernel.org>; Wed, 24 Mar 2021 09:38:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=ZF8HRT5IrNOvQL6Pz8F1OKHc43im4d3pUJ9N+IN8ny4=;
        b=G88ZmMj5H7k8zzXHHampmd8oBFFbkWfA6fSBzQqECpBhAw4mN8MhJrKBkXQO50WvmO
         0SUT3xPwv3MAJNKCtWuHSA3sinSaeXbu1hNNuMDZHq5RjMPzkB5gMt1Roic6kTVHUgom
         J+/jHCmtLyE5WT2fZltXzgb60K9vaDT27sSRMzEhQWVA8S3M62k27dbJ5sU/5ud6NDti
         gPMz5ZNlRICXrn5Xn/EAK6cX9jnkAEof78dxkRykK3RlGiRhQlcioa+ggcUUkBw9zxmd
         E9T5VLEN71Hbf4dCt0tzV7vm/nAMDrj6zG6qyOttp7QCVG/ZEG2gu8C0aRCKrGqn9CVs
         aAlA==
X-Gm-Message-State: AOAM530opZtMD7315CASljQAi1VOm5odzezbmBIIZuo8dhc6Nhivu1mI
        7V9m0NTn80ye/Gw7qY4Q8s31ZWukYR1V5mkYBW72ZWtVIzG3HKprtS5uB8ZtGfGwOfCTM0yzBF5
        BJwKfqyX6DkVo
X-Received: by 2002:adf:e5c4:: with SMTP id a4mr4478175wrn.174.1616603926341;
        Wed, 24 Mar 2021 09:38:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxNX1S2tQyoRha/DwjTPN7h2LrSBGyzP5oxKR2eeHPyyIYZd4C89Eg+f14Opdl72aBTlPS3FQ==
X-Received: by 2002:adf:e5c4:: with SMTP id a4mr4478163wrn.174.1616603926203;
        Wed, 24 Mar 2021 09:38:46 -0700 (PDT)
Received: from redhat.com (bzq-79-183-252-180.red.bezeqint.net. [79.183.252.180])
        by smtp.gmail.com with ESMTPSA id c8sm4151618wrd.55.2021.03.24.09.38.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 09:38:45 -0700 (PDT)
Date:   Wed, 24 Mar 2021 12:38:40 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     "Catangiu, Adrian Costin" <acatan@amazon.com>,
        "Graf (AWS), Alexander" <graf@amazon.de>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "rppt@kernel.org" <rppt@kernel.org>,
        "0x7f454c46@gmail.com" <0x7f454c46@gmail.com>,
        "borntraeger@de.ibm.com" <borntraeger@de.ibm.com>,
        "Jason@zx2c4.com" <Jason@zx2c4.com>,
        "jannh@google.com" <jannh@google.com>, "w@1wt.eu" <w@1wt.eu>,
        "MacCarthaigh, Colm" <colmmacc@amazon.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "tytso@mit.edu" <tytso@mit.edu>,
        "ebiggers@kernel.org" <ebiggers@kernel.org>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "bonzini@gnu.org" <bonzini@gnu.org>,
        "Singh, Balbir" <sblbir@amazon.com>,
        "Weiss, Radu" <raduweis@amazon.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "mhocko@kernel.org" <mhocko@kernel.org>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "pavel@ucw.cz" <pavel@ucw.cz>,
        "mpe@ellerman.id.au" <mpe@ellerman.id.au>,
        "areber@redhat.com" <areber@redhat.com>,
        "ovzxemul@gmail.com" <ovzxemul@gmail.com>,
        "avagin@gmail.com" <avagin@gmail.com>,
        "ptikhomirov@virtuozzo.com" <ptikhomirov@virtuozzo.com>,
        "gil@azul.com" <gil@azul.com>,
        "asmehra@redhat.com" <asmehra@redhat.com>,
        "dgunigun@redhat.com" <dgunigun@redhat.com>,
        "vijaysun@ca.ibm.com" <vijaysun@ca.ibm.com>,
        "oridgar@gmail.com" <oridgar@gmail.com>,
        "ghammer@redhat.com" <ghammer@redhat.com>
Subject: Re: [PATCH v8] drivers/misc: sysgenid: add system generation id
 driver
Message-ID: <20210324123756-mutt-send-email-mst@kernel.org>
References: <1615213083-29869-1-git-send-email-acatan@amazon.com>
 <YEY2b1QU5RxozL0r@kroah.com>
 <a61c976f-b362-bb60-50a5-04073360e702@amazon.com>
 <YFnlZQZOasOwxUDn@kroah.com>
 <E6E517FF-A37C-427C-B16F-066A965B8F42@amazon.com>
 <YFoYwq/RadewiE8I@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YFoYwq/RadewiE8I@kroah.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 23, 2021 at 05:35:14PM +0100, Greg KH wrote:
> On Tue, Mar 23, 2021 at 04:10:27PM +0000, Catangiu, Adrian Costin wrote:
> > Hi Greg,
> > 
> > After your previous reply on this thread we started considering to provide this interface and framework/functionality through a userspace service instead of a kernel interface.
> > The latest iteration on this evolving patch-set doesn’t have strong reasons for living in the kernel anymore - the only objectively strong advantage would be easier driving of ecosystem integration; but I am not sure that's a good enough reason to create a new kernel interface.
> > 
> > I am now looking into adding this through Systemd. Either as a pluggable service or maybe even a systemd builtin offering.
> > 
> > What are your thoughts on it?
> 
> I'll gladly drop this patch if it's not needed in the kernel, thanks for
> letting me know.
> 
> greg k-h

Systemd sounds good to me too.

-- 
MST

