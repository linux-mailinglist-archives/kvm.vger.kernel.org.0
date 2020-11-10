Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B0532ADA4F
	for <lists+kvm@lfdr.de>; Tue, 10 Nov 2020 16:24:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731200AbgKJPXu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Nov 2020 10:23:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730200AbgKJPXu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Nov 2020 10:23:50 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AB3FC0613CF
        for <kvm@vger.kernel.org>; Tue, 10 Nov 2020 07:23:50 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id v4so13144031edi.0
        for <kvm@vger.kernel.org>; Tue, 10 Nov 2020 07:23:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:subject:message-id:mime-version;
        bh=gOCHIh5D5TR40yXAQvT2S/6AxbLM4QIKz2FjPuBmxCI=;
        b=kOTpfNzY8TW0s3msQ6qrJKRDE0VM21bGdyKdmfkMCJeBTyC+rCKbQBXFD3G3C2DBWC
         UJBQii2KwAdLSS0VdPG4uRbzhIpkWhEYlfc5C16BJNl0M+O/+L7ixykwvtWu8RlA38f+
         sEtcPSetLpzXpOQUvb1pRgSy+hxCSPCar7J6/66l8j9VVJNKG9K5bhSbckcATBgBvh6G
         YJO68AqBx6IAjpqsqi7a3OeXz4I5GwErfSvZJppJAJVGxIft/Y3HC0moIuwtAWNGVWc5
         yPf57ixmvFkvxYWzzkeK86Qxc4ASQ47fnKFBdUW/lxkwrTvV9qmLTXx8/mTYN6A8S+eM
         7SLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version;
        bh=gOCHIh5D5TR40yXAQvT2S/6AxbLM4QIKz2FjPuBmxCI=;
        b=hBFZxO1kCq+aXwmcik2H87f6KANKrfTUMwnLFWbOOjVibEBgMeZIvbp0USu3Y+1nbr
         0axYvxdzhNp6BElzhvckf78P2ZHYsmfepzl9kPz7SH5vGV44nRxLXmDzuwvvOel9cGzQ
         nDfp8Smh9EcPlB4ENt8atBOzePA9s9Frw8+cdXtWpiFCw8jUZxhsH/6E2sxlcKDBhzfq
         LSVWntl9bfq+Pu1erQV5wcjCX0yD/b148bWSI4nDIBabSgS2PafGaYUXeRRVUsm094DR
         /oIREgq6YNyuiTPdFQD7ssAR7z0tA1wcVtICAWXieTpSpAcNNZ+LZFJL9SslcWnD5Rd7
         ZboQ==
X-Gm-Message-State: AOAM531EY4TS4k6n6aQhc3KBrDKnWydSrKWbhBlKYbpuzuI8TB1wfLo1
        7hVIVH9Y5Ko+YlqxoB5myaK5poKL5nQ=
X-Google-Smtp-Source: ABdhPJy9W2hgLoJYAQA1t5wLt771mBwLsLi4/lWMR4pyasQR2CpKg7NOGaxk7Dq1QxRwBS20abZmFw==
X-Received: by 2002:a05:6402:1119:: with SMTP id u25mr22381984edv.37.1605021828677;
        Tue, 10 Nov 2020 07:23:48 -0800 (PST)
Received: from vm1 (ip-86-49-65-192.net.upcbroadband.cz. [86.49.65.192])
        by smtp.gmail.com with ESMTPSA id d23sm10847036edp.36.2020.11.10.07.23.48
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2020 07:23:48 -0800 (PST)
Date:   Tue, 10 Nov 2020 16:23:44 +0100
From:   Zdenek Kaspar <zkaspar82@gmail.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Unable to start VM with 5.10-rc3
Message-ID: <20201110162344.152663d5.zkaspar82@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/cXeCeD7W453XOh1J6PCNQdz"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--MP_/cXeCeD7W453XOh1J6PCNQdz
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

attached file is result from today's linux-master (with fixes
for 5.10-rc4) when I try to start VM on older machine:

model name      : Intel(R) Core(TM)2 CPU          6600  @ 2.40GHz
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ht tm pbe syscall nx lm constant_tsc arch_perfmon pebs bts rep_good nopl cpuid aperfmperf pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm lahf_lm pti tpr_shadow dtherm
vmx flags       : tsc_offset vtpr

I did quick check with 5.9 (distro kernel) and it works,
but VM performance seems extremely impacted. 5.8 works fine.

Back to 5.10 issue: it's problematic since 5.10-rc1 and I have no luck
with bisecting (machine doesn't boot).

TIA, Z.

--MP_/cXeCeD7W453XOh1J6PCNQdz
Content-Type: application/octet-stream; name=kvm-5.10-rc3-oops
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename=kvm-5.10-rc3-oops

WyAgMjg3LjMwNzI4N10gQlVHOiBrZXJuZWwgTlVMTCBwb2ludGVyIGRlcmVmZXJlbmNlLCBhZGRy
ZXNzOiAwMDAwMDAwMDAwMDAwMGE0ClsgIDI4Ny4zMDczNDJdICNQRjogc3VwZXJ2aXNvciByZWFk
IGFjY2VzcyBpbiBrZXJuZWwgbW9kZQpbICAyODcuMzA3MzcwXSAjUEY6IGVycm9yX2NvZGUoMHgw
MDAwKSAtIG5vdC1wcmVzZW50IHBhZ2UKWyAgMjg3LjMwNzM5OF0gUEdEIDAgUDREIDAgClsgIDI4
Ny4zMDc0MTVdIE9vcHM6IDAwMDAgWyMxXSBQUkVFTVBUIFNNUCBQVEkKWyAgMjg3LjMwNzQ0M10g
Q1BVOiAxIFBJRDogNjA4IENvbW06IHFlbXUtYnVpbGQgTm90IHRhaW50ZWQgNS4xMC4wLXJjMy0x
LWFtZDY0ICMxClsgIDI4Ny4zMDc0ODNdIEhhcmR3YXJlIG5hbWU6ICAvREczNUVDLCBCSU9TIEVD
RzM1MTBNLjg2QS4wMTE4LjIwMTAuMDExMy4xNDI2IDAxLzEzLzIwMTAKWyAgMjg3LjMwNzU0OV0g
UklQOiAwMDEwOmlzX3RkcF9tbXVfcm9vdCsweDEzLzB4MzAgW2t2bV0KWyAgMjg3LjMwNzU3OF0g
Q29kZTogNDggOGIgODcgODggOTIgMDAgMDAgNDggODEgYzcgODggOTIgMDAgMDAgNDggMzkgZjgg
NzUgMDEgYzMgMGYgMGIgYzMgNDggYzEgZWUgMGMgNDggYzEgZTYgMDYgNDggMDMgMzUgNDEgOTEg
MjkgYzkgNDggOGIgNTYgMjggPDBmPiBiNiA4MiBhNCAwMCAwMCAwMCA4NCBjMCA3NCAwOCA4YiA0
MiA1MCA4NSBjMCAwZiA5NSBjMCBjMyA2NiAwZgpbICAyODcuMzA3Njg3XSBSU1A6IDAwMTg6ZmZm
ZmIwMTljMDZjN2M3MCBFRkxBR1M6IDAwMDEwMjgyClsgIDI4Ny4zMDc3MTddIFJBWDogZmZmZjli
ZGViMGE0NDM4OCBSQlg6IDAwMDAwMDAwMDAwMDAwMDAgUkNYOiAwMDAwMDAwMDAwMDAwMDAwClsg
IDI4Ny4zMDc3NTZdIFJEWDogMDAwMDAwMDAwMDAwMDAwMCBSU0k6IGZmZmZlM2JkODA2YjA3ODAg
UkRJOiBmZmZmYjAxOWMwOTg1MDAwClsgIDI4Ny4zMDc3OTVdIFJCUDogMDAwMDAwMDAwMDBmZTAw
MCBSMDg6IDAwMDAwMDAwMDAwMDAwMDIgUjA5OiAwMDAwMDAwMDAwMDAwMDAwClsgIDI4Ny4zMDc4
MzRdIFIxMDogMDAwMDAwMDAwMDAwMDAwMCBSMTE6IDAwMDAwMDAwMDAwMDAwMDAgUjEyOiAwMDAw
MDAwMDAwMDAwMDE0ClsgIDI4Ny4zMDc4NzNdIFIxMzogZmZmZjliZGViMGE0NDAwMCBSMTQ6IDAw
MDAwMDAwMDAwMDAwMDAgUjE1OiAwMDAwMDAwMDAwMDAwMDAxClsgIDI4Ny4zMDc5MTNdIEZTOiAg
MDAwMDdmN2Y5MzY4NDY0MCgwMDAwKSBHUzpmZmZmOWJkZWZmMjgwMDAwKDAwMDApIGtubEdTOjAw
MDAwMDAwMDAwMDAwMDAKWyAgMjg3LjMwNzk1N10gQ1M6ICAwMDEwIERTOiAwMDAwIEVTOiAwMDAw
IENSMDogMDAwMDAwMDA4MDA1MDAzMwpbICAyODcuMzA3OTg4XSBDUjI6IDAwMDAwMDAwMDAwMDAw
YTQgQ1IzOiAwMDAwMDAwMDQ4MmVlMDAwIENSNDogMDAwMDAwMDAwMDAwMjZlMApbICAyODcuMzA4
MDI3XSBDYWxsIFRyYWNlOgpbICAyODcuMzA4MDU1XSAgZGlyZWN0X3BhZ2VfZmF1bHQrMHg2Ni8w
eDkwMCBba3ZtXQpbICAyODcuMzA4MDk0XSAgPyB3cml0ZWJhY2tfcmVnaXN0ZXJzKzB4MTgvMHg2
MCBba3ZtXQpbICAyODcuMzA4MTMzXSAgPyB4ODZfZW11bGF0ZV9pbnNuKzB4NWVlLzB4ZTEwIFtr
dm1dClsgIDI4Ny4zMDgxNjldICBrdm1fbW11X3BhZ2VfZmF1bHQrMHgzNDQvMHg0ZjAgW2t2bV0K
WyAgMjg3LjMwODIwMV0gID8gdm14X3ZjcHVfZW50ZXJfZXhpdCsweDVjLzB4OTAgW2t2bV9pbnRl
bF0KWyAgMjg3LjMwODI0M10gIGt2bV9hcmNoX3ZjcHVfaW9jdGxfcnVuKzB4Y2FhLzB4MWM2MCBb
a3ZtXQpbICAyODcuMzA4Mjg0XSAga3ZtX3ZjcHVfaW9jdGwrMHgyMDMvMHg1MjAgW2t2bV0KWyAg
Mjg3LjMwODMxM10gIF9feDY0X3N5c19pb2N0bCsweDMzOC8weDcyMApbICAyODcuMzA4MzM4XSAg
PyBfX3g2NF9zeXNfZnV0ZXgrMHgxMjAvMHgxOTAKWyAgMjg3LjMwODM2Ml0gID8gcmVzdG9yZV9h
bHRzdGFjaysweDE0LzB4YzAKWyAgMjg3LjMwODM4OF0gIGRvX3N5c2NhbGxfNjQrMHgzMy8weDQw
ClsgIDI4Ny4zMDg0MDldICBlbnRyeV9TWVNDQUxMXzY0X2FmdGVyX2h3ZnJhbWUrMHg0NC8weGE5
ClsgIDI4Ny4zMDg0MzhdIFJJUDogMDAzMzoweDdmN2Y5NGJkMWY2YgpbICAyODcuMzA4NDU3XSBD
b2RlOiA4OSBkOCA0OSA4ZCAzYyAxYyA0OCBmNyBkOCA0OSAzOSBjNCA3MiBiNSBlOCAxYyBmZiBm
ZiBmZiA4NSBjMCA3OCBiYSA0YyA4OSBlMCA1YiA1ZCA0MSA1YyBjMyBmMyAwZiAxZSBmYSBiOCAx
MCAwMCAwMCAwMCAwZiAwNSA8NDg+IDNkIDAxIGYwIGZmIGZmIDczIDAxIGMzIDQ4IDhiIDBkIGQ1
IGFlIDBjIDAwIGY3IGQ4IDY0IDg5IDAxIDQ4ClsgIDI4Ny4zMDg1NjNdIFJTUDogMDAyYjowMDAw
N2Y3ZjkzNjgzNjI4IEVGTEFHUzogMDAwMDAyNDYgT1JJR19SQVg6IDAwMDAwMDAwMDAwMDAwMTAK
WyAgMjg3LjMxMDUwNl0gUkFYOiBmZmZmZmZmZmZmZmZmZmRhIFJCWDogMDAwMDAwMDAwMDAwYWU4
MCBSQ1g6IDAwMDA3ZjdmOTRiZDFmNmIKWyAgMjg3LjMxMjQ1MV0gUkRYOiAwMDAwMDAwMDAwMDAw
MDAwIFJTSTogMDAwMDAwMDAwMDAwYWU4MCBSREk6IDAwMDAwMDAwMDAwMDAwMTIKWyAgMjg3LjMx
NDMzNl0gUkJQOiAwMDAwNTU3MGI4MDMyYWYwIFIwODogMDAwMDU1NzBiNjBlNjg1MCBSMDk6IDAw
MDA1NTcwYjY2Zjk2MjAKWyAgMjg3LjMxNjIxMl0gUjEwOiAwMDAwMDAwMDAwMDAwMDAwIFIxMTog
MDAwMDAwMDAwMDAwMDI0NiBSMTI6IDAwMDAwMDAwMDAwMDAwMDAKWyAgMjg3LjMxODA4MF0gUjEz
OiAwMDAwNTU3MGI2NmRiODAwIFIxNDogMDAwMDAwMDAwMDAwMDAwMCBSMTU6IDAwMDA3ZjdmOTM2
ODQ2NDAKWyAgMjg3LjMxOTkyN10gTW9kdWxlcyBsaW5rZWQgaW46IHZob3N0X25ldCB2aG9zdCB2
aG9zdF9pb3RsYiB0dW4gbmZ0X3JlamVjdF9pcHY0IG5mX3JlamVjdF9pcHY0IG5mdF9yZWplY3Qg
bmZfdGFibGVzIG5mbmV0bGluayB2ZXRoIG5mc2QgeHhoYXNoX2dlbmVyaWMgbmhwb2x5MTMwNV9z
c2UyIG5ocG9seTEzMDUgY2hhY2hhX2dlbmVyaWMgY2hhY2hhX3g4Nl82NCBsaWJjaGFjaGEgYWRp
YW50dW0gbGlicG9seTEzMDUgYWxnaWZfc2tjaXBoZXIgYWZfYWxnIGF1dGhfcnBjZ3NzIG5mc3Y0
IGRuc19yZXNvbHZlciBuZnMgbG9ja2QgZ3JhY2Ugc3VucnBjIG5mc19zc2MgbHpvIHpyYW0genNt
YWxsb2MgY3B1ZnJlcV9wb3dlcnNhdmUga3ZtX2ludGVsIGk5MTUga3ZtIGlUQ09fd2R0IGxwY19p
Y2ggYnJpZGdlIHZpZGVvIGludGVsX2d0dCBtZmRfY29yZSA4MjUwIGlvc2ZfbWJpIDgyNTBfYmFz
ZSBpcnFieXBhc3MgaTJjX2FsZ29fYml0IGV2ZGV2IGUxMDAwZSBzdHAgbGxjIGRybV9rbXNfaGVs
cGVyIHNlcmlhbF9jb3JlIGFjcGlfY3B1ZnJlcSBwcm9jZXNzb3Igc3lzY29weWFyZWEgc3lzZmls
bHJlY3Qgc3lzaW1nYmx0IGZiX3N5c19mb3BzIGJ1dHRvbiBkcm0gc2NoX2ZxX2NvZGVsIGkyY19j
b3JlIGJhY2tsaWdodCBpcF90YWJsZXMgeF90YWJsZXMgaXB2NiBhdXRvZnM0IGJ0cmZzIGJsYWtl
MmJfZ2VuZXJpYyBsaWJjcmMzMmMgY3JjMzJjX2dlbmVyaWMgeG9yIHpzdGRfZGVjb21wcmVzcyB6
c3RkX2NvbXByZXNzIGx6b19jb21wcmVzcyBsem9fZGVjb21wcmVzcyByYWlkNl9wcSBlY2IgeHRz
IGRtX2NyeXB0IGRtX21vZCBzZF9tb2QgdDEwX3BpIGhpZF9nZW5lcmljIHVzYmhpZCBoaWQgdWhj
aV9oY2QgZWhjaV9wY2kgZWhjaV9oY2QgYWhjaSBzYXRhX3NpbDI0IHBhdGFfam1pY3JvbiBsaWJh
aGNpIHVzYmNvcmUgdXNiX2NvbW1vbgpbICAyODcuMzMyNDU0XSBDUjI6IDAwMDAwMDAwMDAwMDAw
YTQKWyAgMjg3LjMzNDY4M10gLS0tWyBlbmQgdHJhY2UgYWJiNzUwMDBiZGNhZTcwNiBdLS0tClsg
IDI4Ny4zMzY5MjJdIFJJUDogMDAxMDppc190ZHBfbW11X3Jvb3QrMHgxMy8weDMwIFtrdm1dClsg
IDI4Ny4zMzkyMTFdIENvZGU6IDQ4IDhiIDg3IDg4IDkyIDAwIDAwIDQ4IDgxIGM3IDg4IDkyIDAw
IDAwIDQ4IDM5IGY4IDc1IDAxIGMzIDBmIDBiIGMzIDQ4IGMxIGVlIDBjIDQ4IGMxIGU2IDA2IDQ4
IDAzIDM1IDQxIDkxIDI5IGM5IDQ4IDhiIDU2IDI4IDwwZj4gYjYgODIgYTQgMDAgMDAgMDAgODQg
YzAgNzQgMDggOGIgNDIgNTAgODUgYzAgMGYgOTUgYzAgYzMgNjYgMGYKWyAgMjg3LjM0Mzg5MV0g
UlNQOiAwMDE4OmZmZmZiMDE5YzA2YzdjNzAgRUZMQUdTOiAwMDAxMDI4MgpbICAyODcuMzQ2Mjcy
XSBSQVg6IGZmZmY5YmRlYjBhNDQzODggUkJYOiAwMDAwMDAwMDAwMDAwMDAwIFJDWDogMDAwMDAw
MDAwMDAwMDAwMApbICAyODcuMzQ4NjY1XSBSRFg6IDAwMDAwMDAwMDAwMDAwMDAgUlNJOiBmZmZm
ZTNiZDgwNmIwNzgwIFJESTogZmZmZmIwMTljMDk4NTAwMApbICAyODcuMzUxMDg1XSBSQlA6IDAw
MDAwMDAwMDAwZmUwMDAgUjA4OiAwMDAwMDAwMDAwMDAwMDAyIFIwOTogMDAwMDAwMDAwMDAwMDAw
MApbICAyODcuMzUzNDk5XSBSMTA6IDAwMDAwMDAwMDAwMDAwMDAgUjExOiAwMDAwMDAwMDAwMDAw
MDAwIFIxMjogMDAwMDAwMDAwMDAwMDAxNApbICAyODcuMzU1OTEyXSBSMTM6IGZmZmY5YmRlYjBh
NDQwMDAgUjE0OiAwMDAwMDAwMDAwMDAwMDAwIFIxNTogMDAwMDAwMDAwMDAwMDAwMQpbICAyODcu
MzU4MzM2XSBGUzogIDAwMDA3ZjdmOTM2ODQ2NDAoMDAwMCkgR1M6ZmZmZjliZGVmZjI4MDAwMCgw
MDAwKSBrbmxHUzowMDAwMDAwMDAwMDAwMDAwClsgIDI4Ny4zNjA3NjhdIENTOiAgMDAxMCBEUzog
MDAwMCBFUzogMDAwMCBDUjA6IDAwMDAwMDAwODAwNTAwMzMKWyAgMjg3LjM2MzIwN10gQ1IyOiAw
MDAwMDAwMDAwMDAwMGE0IENSMzogMDAwMDAwMDA0ODJlZTAwMCBDUjQ6IDAwMDAwMDAwMDAwMDI2
ZTAK

--MP_/cXeCeD7W453XOh1J6PCNQdz--
