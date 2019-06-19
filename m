Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC05D4B310
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2019 09:27:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730987AbfFSH1G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jun 2019 03:27:06 -0400
Received: from mail.acehprov.go.id ([123.108.97.111]:33960 "EHLO
        mail.acehprov.go.id" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725854AbfFSH1F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jun 2019 03:27:05 -0400
X-Greylist: delayed 320 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Jun 2019 03:27:04 EDT
Received: from localhost (localhost [127.0.0.1])
        by mail.acehprov.go.id (Postfix) with ESMTP id 6527830547E0;
        Wed, 19 Jun 2019 14:24:56 +0700 (WIB)
Received: from mail.acehprov.go.id ([127.0.0.1])
        by localhost (mail.acehprov.go.id [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id S0ZHR74-_u9t; Wed, 19 Jun 2019 14:24:56 +0700 (WIB)
Received: from mail.acehprov.go.id (localhost [127.0.0.1])
        by mail.acehprov.go.id (Postfix) with ESMTPS id 2FE4C3054676;
        Wed, 19 Jun 2019 14:24:55 +0700 (WIB)
DKIM-Filter: OpenDKIM Filter v2.8.0 mail.acehprov.go.id 2FE4C3054676
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acehprov.go.id;
        s=327C6C40-AE75-11E3-A0E3-F52F162F8E7F; t=1560929095;
        bh=52PESuH/C2hYB4U2EfLHG/Elk+RBHFGehFYxprn7ClQ=;
        h=Date:From:Reply-To:Message-ID:Subject:MIME-Version:Content-Type:
         Content-Transfer-Encoding;
        b=M3U/if6OHTHLkdkV56SfXf9wlra0jzkOEAtwJkOnLxK3wimaq0pWOPRT3056Bkbwy
         Aut4s87IJVHkbp9evkj/5S5MAf27+c8/1zE5LBiqsTGktpHZg8ofrMZPZnfqCDHzTb
         vQ1pr4dfS8GoOC6rvjGTNDDASxqjZYk1CAlDDenI=
Received: from mail.acehprov.go.id (mail.acehprov.go.id [123.108.97.111])
        by mail.acehprov.go.id (Postfix) with ESMTP id 95DA93053CF8;
        Wed, 19 Jun 2019 14:24:53 +0700 (WIB)
Date:   Wed, 19 Jun 2019 14:24:53 +0700 (WIT)
From:   =?utf-8?B?UXXhuqNuIHRy4buLIGjhu4cgdGjhu5FuZy4=?= 
        <firman_hidayah@acehprov.go.id>
Reply-To: mailsss@mail2world.com
Message-ID: <1495179215.110477.1560929093514.JavaMail.zimbra@acehprov.go.id>
Subject: 
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: base64
X-Originating-IP: [223.225.81.121]
X-Mailer: Zimbra 8.0.4_GA_5737 (zclient/8.0.4_GA_5737)
Thread-Topic: 
Thread-Index: s+KVrvK1spoooFrmcUQLYhXWiXw10g==
To:     unlisted-recipients:; (no To-header on input)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Q0jDmiDDnTsKCkjhu5lwIHRoxrAgY+G7p2EgYuG6oW4gxJHDoyB2xrDhu6N0IHF1w6EgZ2nhu5tp
IGjhuqFuIGzGsHUgdHLhu68sIGzDoCA1IEdCIHRoZW8gcXV5IMSR4buLbmggY+G7p2EgcXXhuqNu
IHRy4buLIHZpw6puLCBuZ8aw4budaSBoaeG7h24gxJFhbmcgY2jhuqF5IHRyw6puIDEwLDkgR0Is
IGLhuqFuIGtow7RuZyB0aOG7gyBn4butaSBob+G6t2Mgbmjhuq1uIHRoxrAgbeG7m2kgY2hvIMSR
4bq/biBraGkgYuG6oW4geMOhYyB0aOG7sWMgbOG6oWkgaOG7mXAgdGjGsCBj4bunYSBtw6xuaC4g
xJDhu4MgeMOhYyBuaOG6rW4gbOG6oWkgaOG7mXAgdGjGsCBj4bunYSBi4bqhbiwgZ+G7rWkgdGjD
tG5nIHRpbiBzYXUgxJHDonk6CgpUw6puOgpUw6puIMSRxINuZyBuaOG6rXA6Cm3huq10IGto4bqp
dToKWMOhYyBuaOG6rW4gbeG6rXQga2jhuql1OgpFLW1haWw6CsSRaeG7h24gdGhv4bqhaToKCk7h
ur91IGLhuqFuIGtow7RuZyB0aOG7gyB4w6FjIG5o4bqtbiBs4bqhaSBo4buZcCB0aMawIGPhu6dh
IG3DrG5oLCBo4buZcCB0aMawIGPhu6dhIGLhuqFuIHPhur0gYuG7iyB2w7QgaGnhu4d1IGjDs2Eh
CgpYaW4gbOG7l2kgdsOsIHPhu7EgYuG6pXQgdGnhu4duLgpNw6MgeMOhYyBtaW5oOiBlbjogMDA2
LDUyNC5SVQpI4buXIHRy4bujIGvhu7kgdGh14bqtdCB0aMawIMKpIDIwMTkKCmPhuqNtIMahbiBi
4bqhbgpRdeG6o24gdHLhu4sgaOG7hyB0aOG7kW5nLg==
