Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D4F54B319
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2019 09:31:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730756AbfFSHbD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jun 2019 03:31:03 -0400
Received: from mail.acehprov.go.id ([123.108.97.111]:40028 "EHLO
        mail.acehprov.go.id" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725980AbfFSHbD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jun 2019 03:31:03 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.acehprov.go.id (Postfix) with ESMTP id 8B840305433C;
        Wed, 19 Jun 2019 14:18:37 +0700 (WIB)
Received: from mail.acehprov.go.id ([127.0.0.1])
        by localhost (mail.acehprov.go.id [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id Lvqn1q0oIP26; Wed, 19 Jun 2019 14:18:36 +0700 (WIB)
Received: from mail.acehprov.go.id (localhost [127.0.0.1])
        by mail.acehprov.go.id (Postfix) with ESMTPS id E21B830541E5;
        Wed, 19 Jun 2019 14:18:35 +0700 (WIB)
DKIM-Filter: OpenDKIM Filter v2.8.0 mail.acehprov.go.id E21B830541E5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acehprov.go.id;
        s=327C6C40-AE75-11E3-A0E3-F52F162F8E7F; t=1560928716;
        bh=52PESuH/C2hYB4U2EfLHG/Elk+RBHFGehFYxprn7ClQ=;
        h=Date:From:Reply-To:Message-ID:Subject:MIME-Version:Content-Type:
         Content-Transfer-Encoding;
        b=q7wmA519Qoaq4b2MQDCyvXLkFEu4MJY829rY1pl1W5k0mwagcZ13YkWA2AFhYbTaI
         LhFwjqoG4ai2Ox0lQioHMbla+qBBpB/2sdrJhU9bSKpc4t3kS+HCqxzYIzVhVd/qlx
         T4nAmoNcznzafKF2b9HgQUSbhmfGdDMSoosgWYNo=
Received: from mail.acehprov.go.id (mail.acehprov.go.id [123.108.97.111])
        by mail.acehprov.go.id (Postfix) with ESMTP id 73AD8304EC32;
        Wed, 19 Jun 2019 14:18:34 +0700 (WIB)
Date:   Wed, 19 Jun 2019 14:18:34 +0700 (WIT)
From:   =?utf-8?B?UXXhuqNuIHRy4buLIGjhu4cgdGjhu5FuZy4=?= 
        <firman_hidayah@acehprov.go.id>
Reply-To: mailsss@mail2world.com
Message-ID: <889758762.107212.1560928714116.JavaMail.zimbra@acehprov.go.id>
Subject: 
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: base64
X-Originating-IP: [223.225.81.121]
X-Mailer: Zimbra 8.0.4_GA_5737 (zclient/8.0.4_GA_5737)
Thread-Topic: 
Thread-Index: dsl93RT9hcmpcnn+la0K/RDmCUC5VQ==
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
