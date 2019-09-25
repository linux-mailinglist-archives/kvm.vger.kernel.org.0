Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFBD6BDF62
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2019 15:47:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406964AbfIYNrS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Sep 2019 09:47:18 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:60492 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2406005AbfIYNrR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Sep 2019 09:47:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1569419236;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xpfWQ+3l5MSN4bfoMIEWdxcV78ruRjJ75JnJ+DzvfgI=;
        b=b8bEwo/7mCsTmC0HHQBlZ9CzOssR5/8/+27GLwmuauGho9YtcbZ1MPV7/4uNjG69J2diGK
        1wY1laPO6beBB/fUMTvKZgpmR1jUVmYbkvhKSmooZ9hGKMu5BxNOnBJdk4xWkFal3Wups/
        xofVc5xMaQOmHX7BjGeKeP1+cAMG+vI=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-1-uHLfZV2WOzGsMfiuN-K4PQ-1; Wed, 25 Sep 2019 09:47:14 -0400
Received: by mail-wm1-f72.google.com with SMTP id t185so2091366wmg.4
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2019 06:47:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ko4435yRw9Yv3DNjR7Hswj2xhLo0bIUq3d7aCuiN4f8=;
        b=iaA4ssfL2Goqxu3wIxoTw3PYfpgohSoyqTUf2UJm2xJTSBoCCXt50YbniDs90pMmg9
         JymWPJahIhQOMj09gPZDxdBowCxUI6LqZ+PJQ1soehT9eNlto6/xOBb/Gn/9eGz47Vpt
         SUYAhUTnFh3t5rxtuCDkpubeQ6BWIU0H25y1XSzOJ5BMOvCXd69l6WrZvHrgeex1yzoD
         Vt4dq518KKC9Z0W4NIhF14pOh4LmvWTemgwIBOgIAT14LEuDPYGcw2gtxvmQrnC1jqZ+
         ocIz9oc+yNuV+RFcrY+iZ9ZDkZ1S848oPK3egnoT8+2AvaGb6qeg+HMGSe70+MM8TNct
         F23g==
X-Gm-Message-State: APjAAAWe1210aziAxftccoHBgCbGaBcw8mu1oJKgtzfQrMJpudyOwTFB
        91RT76w6tGbOEAmMEUdstN+EWVqIGofGpvfRHTqO8r1TL1MTwvAAFhNOd7VvAFaqZ0r0rZ2YFR8
        2vgmKa4cEi1Uw
X-Received: by 2002:adf:f151:: with SMTP id y17mr9361046wro.244.1569419233617;
        Wed, 25 Sep 2019 06:47:13 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzQGBnmifbzZ2zndVPb7pgcLlrQuMSVItc5DAxlRPkNJ6UIGUiNwZQ9P2gQcQUzJbXNujGX1A==
X-Received: by 2002:adf:f151:: with SMTP id y17mr9361025wro.244.1569419233335;
        Wed, 25 Sep 2019 06:47:13 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9520:22e6:6416:5c36? ([2001:b07:6468:f312:9520:22e6:6416:5c36])
        by smtp.gmail.com with ESMTPSA id c21sm2088720wmb.46.2019.09.25.06.47.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Sep 2019 06:47:12 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH] kvm-unit-test: x86: Add RDPRU test
To:     Jim Mattson <jmattson@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm list <kvm@vger.kernel.org>, Peter Shier <pshier@google.com>
References: <20190919230225.37796-1-jmattson@google.com>
 <368a94f2-3614-a9ea-3f72-d53d36a81f68@oracle.com>
 <CALMp9eQh445HEfw0rbUaJQhb7TeFszQX1KXe8YY-18FyMd6+tA@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <9b9b6373-f000-cdc3-6cde-81f05bc5e66e@redhat.com>
Date:   Wed, 25 Sep 2019 15:47:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eQh445HEfw0rbUaJQhb7TeFszQX1KXe8YY-18FyMd6+tA@mail.gmail.com>
Content-Language: en-US
X-MC-Unique: uHLfZV2WOzGsMfiuN-K4PQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/09/19 21:44, Jim Mattson wrote:
> However, I should modify the test so it passes (or skips) on hardware. :-=
)

This should do.

diff --git a/x86/rdpru.c b/x86/rdpru.c
index a298960..3cdb2d6 100644
--- a/x86/rdpru.c
+++ b/x86/rdpru.c
@@ -16,8 +16,10 @@ int main(int ac, char **av)
 {
 =09setup_idt();
=20
-=09report("RDPRU not supported", !this_cpu_has(X86_FEATURE_RDPRU));
-=09report("RDPRU raises #UD", rdpru_checking() =3D=3D UD_VECTOR);
+=09if (this_cpu_has(X86_FEATURE_RDPRU))
+=09=09report_skip("RDPRU raises #UD");
+=09else
+=09=09report("RDPRU raises #UD", rdpru_checking() =3D=3D UD_VECTOR);
=20
 =09return report_summary();
 }

Paolo

