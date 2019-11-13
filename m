Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36E38FAC04
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2019 09:23:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727440AbfKMIXf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Nov 2019 03:23:35 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:54696 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726923AbfKMIXd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Nov 2019 03:23:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573633412;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=vqVZDFat0PMM6C+YZWmr17Dxnrkmoud9CsYgAO3Sp2M=;
        b=W9QXUVLg/+VsZaW56s95tNzkHqWrCaPKCd4n7hMAjP70e7KjMRBAq1DMIHErzpJzYCTztn
        jdmaJD+jo8uD3nVFFqvGvoOrnAvzgvpzvrQfssp3s4G5C2sVwUxrE7Sc9WJDpSqSV4noPf
        12U5Qhyco3hQft+fzNhQ1ZNWnSjott0=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-189-8yob1Rd_MJiPTTitN4MFHg-1; Wed, 13 Nov 2019 03:23:30 -0500
Received: by mail-wr1-f72.google.com with SMTP id j17so1161387wru.13
        for <kvm@vger.kernel.org>; Wed, 13 Nov 2019 00:23:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5Mx/AGAaP+j6yF2jjolqE4bxLZFV7ALbdD3tA1UDj6I=;
        b=phaiG0B94SgHNJbqvY+4R8ZKgB4uiSlzH8xK1VSgFeYoR3mft3/DJHt9tCLslKngjc
         y2RxnmKiWQImF5jLdZtMs13TRVvQNySk5+dXRRctTPrnVrdAarcfMtVOsRXpKHA0N4BV
         UAa59HeQQ1Qv5+FaTYWlToKJRl+4bxHhKJwfT1r5QeF+6tF7N0zoln0w3PK8/v73YsiY
         wY0qzW1uhkYJyuIBP/oQ2lcHanktijHrcLBeWbHuqYIngsEenZLCyvwpmlxFArKLC74B
         nm2mogmTHTle9MJWpUVNrh5vTcGpridA534Ei18mosWvdz3RE1DWktBovGea3XFh+ivH
         DA5Q==
X-Gm-Message-State: APjAAAVJ5Fprq+H/slOeL4CydkWVTI22RAC7cPBfSMYZ1x/ZUIq0dr5B
        IxOJ8aV29q2cDyo66rZpUxzKS5l3DJFqiuvSOowycdXs48DUmQctxjJIq/+yTczmrerVRDl6B/b
        H6oPssJqxelib
X-Received: by 2002:a5d:4f06:: with SMTP id c6mr1555708wru.211.1573633409451;
        Wed, 13 Nov 2019 00:23:29 -0800 (PST)
X-Google-Smtp-Source: APXvYqwiYyk8fUvAknJQ+JRzrcddJ66kvKLs3AvbR+PScIPgNAa903yr90BKUugKeMCMJGwa+X50Yg==
X-Received: by 2002:a5d:4f06:: with SMTP id c6mr1555683wru.211.1573633409147;
        Wed, 13 Nov 2019 00:23:29 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:8c9d:1a6f:4730:367c? ([2001:b07:6468:f312:8c9d:1a6f:4730:367c])
        by smtp.gmail.com with ESMTPSA id 91sm1952882wrm.42.2019.11.13.00.23.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Nov 2019 00:23:28 -0800 (PST)
Subject: Re: [FYI PATCH 0/7] Mitigation for CVE-2018-12207
To:     Jan Kiszka <jan.kiszka@siemens.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Ralf Ramsauer <ralf.ramsauer@oth-regensburg.de>,
        "Gupta, Pawan Kumar" <pawan.kumar.gupta@intel.com>
References: <1573593697-25061-1-git-send-email-pbonzini@redhat.com>
 <23353382-53ea-8b20-7e30-763ef6df374c@siemens.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <ea5a084b-e047-6677-b8fe-d7bb6f8c0ef8@redhat.com>
Date:   Wed, 13 Nov 2019 09:23:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <23353382-53ea-8b20-7e30-763ef6df374c@siemens.com>
Content-Language: en-US
X-MC-Unique: 8yob1Rd_MJiPTTitN4MFHg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/11/19 07:38, Jan Kiszka wrote:
> When reading MCE, error code 0150h, ie. SRAR, I was wondering if that
> couldn't simply be handled by the host. But I suppose the symptom of
> that erratum is not "just" regular recoverable MCE, rather
> sometimes/always an unrecoverable CPU state, despite the error code, righ=
t?

The erratum documentation talks explicitly about hanging the system, but
it's not clear if it's just a result of the OS mishandling the MCE, or
something worse.  So I don't know. :(  Pawan, do you?

Paolo

