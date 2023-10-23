Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAACF7D2BAB
	for <lists+kvm@lfdr.de>; Mon, 23 Oct 2023 09:46:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233409AbjJWHqv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 03:46:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbjJWHqt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 03:46:49 -0400
X-Greylist: delayed 183 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 23 Oct 2023 00:46:46 PDT
Received: from mo4-p00-ob.smtp.rzone.de (mo4-p00-ob.smtp.rzone.de [81.169.146.162])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA811CC
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 00:46:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1698047021; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=FVh7E6OnMtic4teXvvhKaKXGe+recMVaZWNr+Y4OnrkKGUcbzfBiZ2JHoBUJkG2kvs
    OLnrEPqZGk7J4VJxTJh9FOxnbeEdeZ1hxkLL7M+M+5PkU3oy0lG3li9RrnIY+hdmdSGI
    KyRjWBRtVtFmL61/nX06UNr6MIA3DRID0h58V9wDsdw1VdsIOxgsxl+42z5SuO1yq4tH
    Tsqo78j99yFw2dd1pLBZrZ1Ke2BQzzIvJzL+0kIxs46g3GwZ2eLBSU5Clze6HWcGIcdo
    ycMF0SIkavtA+GOBS7yh51jus6Wad04sXtIV4lVTiOAW3+pX9gTyY2z/n+8sHBo/G2OT
    WARw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1698047021;
    s=strato-dkim-0002; d=strato.com;
    h=Subject:From:To:Date:Message-ID:Cc:Date:From:Subject:Sender;
    bh=1sEe+xsIeFr6Rc19BhgndoMCNIQVZui+7gYwzPVE/1A=;
    b=Rx8igaVFCMwy/LDi7fyMLycRsgsWM3FT8lScVjk86HF4M297T0Iqj2asYImpFyp4Qh
    y3y5w21acQlF6b0G9GqD+0BhR956cc9YsQ14hs3asKkzc4gvP56ebijndeEgf8aOMepC
    DWfKFPNImZig0CpyNoxNIj0OF4E97oP7x8KeiEIgjxy/ebARbcmvcUS7itda6GlLuhQG
    BIv5ub/pxsVARwsNX90SzE9yYvkM95/sncoGk72Dxn1eh+dR6wuy+vdOmOBGfXVIx129
    lL7o1nZAftNDbzLykKjd2J73ANPmhqh/HrTg0Gt/pWtHEM2JsUmYSjyKUGPahgotWuJ7
    xabg==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo00
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1698047021;
    s=strato-dkim-0002; d=itsslomma.de;
    h=Subject:From:To:Date:Message-ID:Cc:Date:From:Subject:Sender;
    bh=1sEe+xsIeFr6Rc19BhgndoMCNIQVZui+7gYwzPVE/1A=;
    b=p6Q0hz7XOSb+M+xxjTvypElK5HICSz36PTlevvbq1gk/BRl1+2l8May4sFZ2I473rj
    zzatUMcaY/vkLI94kYAcAkckJb1Hje6EUCdSKSv9tkCD+zi+mqQO40sn1k6rFFOu/A2D
    fU5LeXdsd1ZzVeLdxis1/jZ/z3bYMA2zWylUQupva9e3CwivKQ7qvCZPbFomOXZRddIk
    hjoRdDtWKofLS1MLwFaf9A6YkanNAfOobrtD0+yCg6iGjb+7ia8qWVqr84uWRid29Ouz
    4S7hEZXlv8LHxZS5BBjujs2rFY7kFMUoeHUwcp2inPmvdtpPa2DxRmbwhO9Dwv7CFYgm
    nV8w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1698047021;
    s=strato-dkim-0003; d=itsslomma.de;
    h=Subject:From:To:Date:Message-ID:Cc:Date:From:Subject:Sender;
    bh=1sEe+xsIeFr6Rc19BhgndoMCNIQVZui+7gYwzPVE/1A=;
    b=oFNxKVdaWDZW+MhqZJ+bJRW5gjWiZZ8yfIIKz/NwVEWELxSoBIERdq9Zlr0/rWVI9o
    /9H9WFRfRKoBlcpDLFAw==
X-RZG-AUTH: ":K2kWZ0m8NexQ+Y5NHnuAyP6+fJVZHx77D7CeOHU7oISihBj/J0bZiA5AdKGpnrwIizPqxHz0RPs4V+S71giZM4QZ/6yUw1U4CWhRxO0IVYOYOEQfPLs="
Received: from [IPV6:2a02:8109:b301:9000:de87:d577:37a0:f2e2]
    by smtp.strato.de (RZmta 49.9.0 AUTH)
    with ESMTPSA id z33ba8z9N7hfYpl
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate)
    for <kvm@vger.kernel.org>;
    Mon, 23 Oct 2023 09:43:41 +0200 (CEST)
Message-ID: <326f3f16-66f8-4394-ab49-5d943f43f25e@itsslomma.de>
Date:   Mon, 23 Oct 2023 09:43:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To:     kvm@vger.kernel.org
From:   Gerrit Slomma <gerrit.slomma@itsslomma.de>
Subject: odd behaviour of virtualized CPUs
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello

I came upon following behaviour, i think this is a bug, but where to 
file it?
I filed it against qemu-kvm at Red Hat-jira for the time being, but this 
is a closed environment as it seems.

Sourcecode first:
#include <stdio.h>
#include <string.h>
#include <immintrin.h>

void main(void) {
         __m256i test1 = _mm256_set_epi32(1,2,3,4,5,6,7,8);
         __m256i test2 = _mm256_set_epi32(1,2,3,4,5,6,7,8);

         for (int count = 0; count < 8; count++) {
                 printf("[%d] %d ", count, *((int*)(&test1) + count));
         }

         printf("\n");

         for (int count = 0; count < 8; count++) {
                 printf("[%d] %d ", count, *((int*)(&test2) + count));
         }

         printf("\n");
         test1 = _mm256_add_epi32(test1, test2);
         test2 = _mm256_mullo_epi32(test1, test2);

         for (int count = 0; count < 8; count++) {
                 printf("[%d] %d ", count, *((int*)(&test1) + count));
         }

         printf("\n");

         for (int count = 0; count < 8; count++) {
                 printf("[%d] %d ", count, *((int*)(&test2) + count));
         }

         printf("\n");
}

Compilation with "gcc -mavx -i avx2 avx2.c" fails, due to used 
intrinsics are AVX2-intrinsics.
When compiled with "gcc -mavx2 -o avx2 avx2.c" an run on a E7-4880v2 
this yields "illegal instruction".
When run on a KVM-virtualized "Sandy Bridge"-CPU, but the underlying CPU 
is capable of AVX2 (i.e. Haswell or Skylake) this runs, despite 
advertised flag is only avx:
$ ./avx2
[0] 8 [1] 7 [2] 6 [3] 5 [4] 4 [5] 3 [6] 2 [7] 1
[0] 8 [1] 7 [2] 6 [3] 5 [4] 4 [5] 3 [6] 2 [7] 1
[0] 16 [1] 14 [2] 12 [3] 10 [4] 8 [5] 6 [6] 4 [7] 2
[0] 128 [1] 98 [2] 72 [3] 50 [4] 32 [5] 18 [6] 8 [7] 2

this holds for FMA3-instructions (i used intrinsic is 
_mm256_fmadd_pd(a,b,c).)

When i emulate the CPU as Westmere it yields "illegal instruction".

Regards, Gerrit
