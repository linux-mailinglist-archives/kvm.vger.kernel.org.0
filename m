Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18D126B6CA0
	for <lists+kvm@lfdr.de>; Mon, 13 Mar 2023 00:40:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229494AbjCLXko (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 19:40:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjCLXkl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 19:40:41 -0400
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AB232A9A1
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 16:40:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1678664439; x=1710200439;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=RLLRtT6owGBbS5OdNnwzYDSBtz4lOaOVM3Cr4zRbo7k=;
  b=MRAvI7OkfkcRN3KV04bZpcIPu6KyekV3AGptmMZAdUxWfk3MNanqgWrz
   59aYaD5/O/mn2q2V8H8oBZhSc0cvfcEgMMgwu29BJo1xaGr522Lwy4Jv1
   PNebmaIKMUDXZ50mxrAR25qAJadv7Wo3xVdCaM33xpWSyYH5ernt9Ttkk
   Giwf+8Hu8kEqBqe+Q4JLWwWOy22Nyo+u4Lw7Q1ssobcCxhyLNCHv3YFOJ
   tycnfOxlM4wBZj1hkRyz8V6Wcy2qP189eYlyF4PaMm9l2GBRT+hz9HY7p
   D/Ounf+hEnVTp8/x9HvvWTxdlHG01tT1EYtPCX1zWGZ5235UQ6xqifJOZ
   A==;
X-IronPort-AV: E=Sophos;i="5.98,254,1673884800"; 
   d="scan'208";a="329827092"
Received: from mail-dm6nam12lp2174.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.174])
  by ob1.hgst.iphmx.com with ESMTP; 13 Mar 2023 07:40:37 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MpZX89w4oHIlXSQFQO7SvH/BlvIpr1W+pE04NKEJxTEb2bIwDfrapNSmnKNPJ0mKEBaGZGe8949bI1PARptr50y7s/6MyLW22gx142UchXOrGXWpqNoFL976zcrg8iBE9wU/AgadbqjCrfeNRP6odsrzcpew8Z2MCwtm8TYEuVIECnJarlBpq3DOOB7wzQMGsTqxYBX/vqDgnOBGQubyRU37IhZk5IaMkMFDRPtlMHgD6KfXNw51fPm17wW3t6OUaV1OW2Co7+e5ixVNqkGDSqeg7k/djFAu203mxVM3o9/pBkKGrFkEViAMbGmE17nM7q6bdTHdI0HsuO/sWAbsLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RLLRtT6owGBbS5OdNnwzYDSBtz4lOaOVM3Cr4zRbo7k=;
 b=FSDwBJDG784T7jkLz30MkvaxKqISgvuBURIiMQb66taU3B7KnPPRggVy2kkqoebzHYWk1aQjokh4xqP1ZQ90L+HrEZNQfT7xRy+Vlf5qTVl12KERJLFqgG6iyx6NSK/o4T+HxojHpYAY/m5Qlk1wmtDFsv/ikKeqgliZRVPUtYSWUezVqSNAkCSmyp2avd0sU1kfjdxtzw/RSjUUtrEpbVmLZF4Xz4FhH3XT5bGfe4abzajhZ1xOgC0UZRcDU/z9bJ6UQct7HvSqa2PBhcBZi1afV17BynDSL/bpfHKlL35NY/l1ckW68RHkf7+FAwClyi0aIHXwm4s7NT2z9xMkKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RLLRtT6owGBbS5OdNnwzYDSBtz4lOaOVM3Cr4zRbo7k=;
 b=YJZxZvW4UBjEQLcHKGQ5b3k9By2JhNpl0Zl+swamr/1kH45/jrYS49xW7dkl7VVwyd7HBe+KeutHMXT/FLorAhji1FhWBePaiJqM+xldwjiolTvz6dn5sWnUJGRPsdES7dk7PCSCWcnEQAJ3Ys3n/2MOnU9GLdNrXU0g5WRW3rk=
Received: from BN6PR04MB0963.namprd04.prod.outlook.com (2603:10b6:405:43::35)
 by DM6PR04MB6330.namprd04.prod.outlook.com (2603:10b6:5:1e4::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Sun, 12 Mar
 2023 23:40:35 +0000
Received: from BN6PR04MB0963.namprd04.prod.outlook.com
 ([fe80::6253:849d:e55e:17bb]) by BN6PR04MB0963.namprd04.prod.outlook.com
 ([fe80::6253:849d:e55e:17bb%7]) with mapi id 15.20.6178.024; Sun, 12 Mar 2023
 23:40:34 +0000
From:   Wilfred Mallawa <wilfred.mallawa@wdc.com>
To:     "lawrence.hunter@codethink.co.uk" <lawrence.hunter@codethink.co.uk>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>
CC:     "frank.chang@sifive.com" <frank.chang@sifive.com>,
        "nazar.kazakov@codethink.co.uk" <nazar.kazakov@codethink.co.uk>,
        "kiran.ostrolenk@codethink.co.uk" <kiran.ostrolenk@codethink.co.uk>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        "dickon.hood@codethink.co.uk" <dickon.hood@codethink.co.uk>,
        "bin.meng@windriver.com" <bin.meng@windriver.com>,
        "palmer@dabbelt.com" <palmer@dabbelt.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "philipp.tomsich@vrull.eu" <philipp.tomsich@vrull.eu>
Subject: Re: [PATCH 04/45] target/riscv: Refactor some of the generic vector
 functionality
Thread-Topic: [PATCH 04/45] target/riscv: Refactor some of the generic vector
 functionality
Thread-Index: AQHZUzCMV5XcWle/NkmB3xdx3Wumj6730bGA
Date:   Sun, 12 Mar 2023 23:40:34 +0000
Message-ID: <3abf8c77b89e9c023f28c9d611607ce950262a29.camel@wdc.com>
References: <20230310091215.931644-1-lawrence.hunter@codethink.co.uk>
         <20230310091215.931644-5-lawrence.hunter@codethink.co.uk>
In-Reply-To: <20230310091215.931644-5-lawrence.hunter@codethink.co.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN6PR04MB0963:EE_|DM6PR04MB6330:EE_
x-ms-office365-filtering-correlation-id: b1a55439-68c8-4762-8206-08db23532cf7
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zGLGYU07AQE288c4CO+y9SuCNC9jE8oBTEyJuP/ma7/KGv9Eo8kFDnYkX/+H993QbvXQGT0RcOKCN26aI2VI8aeFpOjCqkMp21ZQVZGzj3neOhyaMabFlNevWDNiKh2iyKR0yV2/JUj8ynJlc9KOPsen080eO0qPz9xB5Pn6/27bnqguqRsDZBcnvTi/aRaT8gSRh/FPqg5R62OM+cWmnEPiAxW9rj85AjvJ3ErTxOHqzywtyRp1VGIi9atSZFYcu64/8V6KknnqUMxEh6yADyeFEnGpumnaLOrgazkhRQpcPr992tNkLEkR/gtqqlGRUB2YpoQ266QP3tCPH1yQUJQ6kWqSOCSQM3IvdAqo9tKojeaK35+Bone80kdzvYN6Dx0eSSDwWMvtg2bkW3lpGtrsoeOtNo0idbyVP6dLorPk2Qu1QWeUQeNGAV6CKMSvChMNKsCxvR6bWhicqhXNGR6aYSo0hKWnHqMs2GSW04mr00VbS8jlW+tsDAtojyAHKw7Ra6CrEvolqtAExBvKg8n73DvHyapeeEZR9ARRjWFE/MqADPNDn6Xgrr1dcbTP+J1fM/Qrjm49tZQDj002fdHFU3Kg0QEeHEzoh1xC4IT6pZFnIdzt0x/8VvWjIrR3YeLGXjpmoSgvt43batgNagXU7cuFrouBymBkel2RhKRxqyYg8JMjzGytKJxj9aE+6a1Dexh6ZEbJtelT3IiTqwx5PJ4cbobbScW5EmCEXEc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR04MB0963.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(366004)(396003)(39860400002)(376002)(136003)(451199018)(110136005)(8936002)(54906003)(91956017)(41300700001)(478600001)(4326008)(66446008)(66946007)(66556008)(66476007)(64756008)(8676002)(76116006)(36756003)(38070700005)(86362001)(122000001)(38100700002)(82960400001)(26005)(6512007)(6486002)(71200400001)(186003)(7416002)(5660300002)(44832011)(2906002)(316002)(6506007)(83380400001)(2616005)(41533002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bjJONEwyWVluSHFJRXBjRGpJSzBMeEZ4QW5iblUxcm52ZHFaOTlOWTFYUWpN?=
 =?utf-8?B?bEg0WWFJckxZMkZaTlJnaVVyVE9GM3BSeGRZZ082TW8yN1dFYk8yOGNxcDRj?=
 =?utf-8?B?VCs2UDhpWlh0V1h6T3VydXptQWQra2FMOFl4U0RybG5YMGNKRjl5MEMvekNw?=
 =?utf-8?B?VnNVaHQ3elJCUGhlV1lRWlVXMnFmWU0vVjFIbXRvanp2U1VCeTNFeWI5aE9P?=
 =?utf-8?B?YXo3YTdUT3M1VGpCOHFGbmsxSXhsUUdhMjFQczJUbVVxa1JFWlBQN0RvcTA1?=
 =?utf-8?B?RTdqdGo1NWh0SnVLc2VlQjJ1WStDeExjRHlwa0NPU0tZdkRnT1V2U1dkcjda?=
 =?utf-8?B?VVZSaVRVNXRVV0Rza0ZYMk9kNjhoSUVLMGREcW9oZndnOC9zWmRhdnovL08x?=
 =?utf-8?B?UW1TTngxWE4xVE5kazNTcTFDVHQxeGZHa01UdWdDbDY5TlRGK3IxS0EwanR6?=
 =?utf-8?B?d2xRK1d4dUxjY2RoLzRTaVJxcTRVd0RQNVBRWEc2dDgreWttMEY0ZEhBSnhm?=
 =?utf-8?B?MENhQUNNWmJHWmNQNWV0dXJ5eUwrallZbEp0TGdGM2hrTlB4eU9yVU1IaFli?=
 =?utf-8?B?RG9rRzFNZEpqYzNoSzh6WGkyeHdpT0RodUNlZk1Eak1JNWhveWJLbTNzRGcv?=
 =?utf-8?B?RHYzcmZGdk53UlMwYWFaYkZDSklHcWpaNkxKcW5mVkFZcTV4UDkwRzAwVVBr?=
 =?utf-8?B?bU9iNzdLcFNRV1E1d3ZFTG1IUVZ6dmN6dFdnVzhiWVdQWWxRcGxTWnJVL2l2?=
 =?utf-8?B?NWtRcE0vSStrRnMvQXR1bHpzanFtblJQMFpmNU82N3dxS2lDVitJdGUxQlR1?=
 =?utf-8?B?Z1F0RE5iVDZ1eEM2VHhZYUpaTzlXU3dWRTVnMzF5ckpFWXRTUEtWT2l2clRh?=
 =?utf-8?B?RUFYMFZZS0UrWkU0NXhQb1VMckQrRG42OVVYMy84Zmw0eGdDc1VpVzFGRVFi?=
 =?utf-8?B?YXM2VG9UNWk0TGdrZ3dObVRZK0Zac1VYcEsrbXdZNzUyalZOS0wwbjNYdXNo?=
 =?utf-8?B?MzFSRlRCQ1ZHOXY3QXE4YzNvNWRSaFlhdlpFVnMzUHpDVGRRK0ZaZnAwUkxh?=
 =?utf-8?B?dlVzZnNHZFJ0bzlCS3FHOFZnRE56SnBlZnBMKzBiYnhrZEhTangzSmVYNDlX?=
 =?utf-8?B?L1hmckZydzE0cUZmR2EwaFh0RVhmQXRuTHZwSVNjZXFzYk9NbU5Ya0NhakZZ?=
 =?utf-8?B?eXkxZGI1a1NROUlQRk1VSTlmbjJwVW0xMVdSdXpPZy9SN3ovd2NxNFRieU5a?=
 =?utf-8?B?SnV3UG4rdmp0Rm84NXJOSEg4NXY2ODJ6ZUxsNDV0djhTa091SjlpdnNkYnFI?=
 =?utf-8?B?UWpHQ0J0aHI5WDI3eGVOdWRuc0s3RnFSNnZPM0ZzcERXNnoyV0tuQ3p0aVdD?=
 =?utf-8?B?b1I0dFZrWjdxMEw0RlJpeVJHUmx2NGhTQmxzVFk5Zmp1elNOMkF3bnZmOGVz?=
 =?utf-8?B?MERXSGhUbTBESEVTbm9kbGM2UjVpazRwVitYS0txb1dMUll3eUt5VENWMVBT?=
 =?utf-8?B?dnR6WHJNZWhYT0pIcE8rUUpCME45KzU3TGRLTFF3NEQ5aXd4WUN5WEpLWHQv?=
 =?utf-8?B?R1VBdndIOWlmSXUrenZHN2srclVLdy9ZalNNUUdmR09UYnl4dTd1VXdUK2Q5?=
 =?utf-8?B?b05ER1VEMi94WFY4YklxdVIzd1BOY29UWmowOVpJUFdtUldjTFpxTmZVb0VY?=
 =?utf-8?B?dWwxY2hKbFNlQk1sT2l5dlQwV1lUM2ljdUJ6M2Fnd1EwamQ0SU5FajVLQUIw?=
 =?utf-8?B?YjJ4VG1EbzVUY2srajl4YTErNmhORWU1T3VYZ0pOdENLNjR6YjZkVlhaL1Y5?=
 =?utf-8?B?eVhjZC9pc2tsT3pOeW9FS3hxa0UxREN5TlcwbWRjYk9YdFNoMVovOExjT0t1?=
 =?utf-8?B?RXN0UmN4YVFTdklWL1krWnRjWnlFY1lkQ0xSSGN6bWc4aDZZS1VULzc2aVRL?=
 =?utf-8?B?MnRUd0RDaTdrMi9RMXF6YkxERkR5TW5ndUJDc1pPaGtneThZNUcweDJQei9T?=
 =?utf-8?B?dHV6RVc2WFhWOUttK0NFOXhXOEJ1c3RKeDgyVlhtdHdPaVBuRTh2Z1lUaWhR?=
 =?utf-8?B?czdwOGR1NGZBNGVRenNHM1lFeFBGZEtyaVloaWN4MU1vRksvcE1NWDRrcXh5?=
 =?utf-8?B?b2tNMjFNQzU4aVIyUndaQ29GM3FOR2ZEc1ZPd3J0M09wM2U5TGF5NkVNcmJ2?=
 =?utf-8?B?WGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CABFD4F2A9709D4C90F6F8F5CEDAD052@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?bWdpMkduNm96ak9RYkhjYVhUWVM0Nmpad1ZtaW5XMkJaeDZnd0YzQ3dPVmsx?=
 =?utf-8?B?aDlpMCswdEprWXNwVTE3akJHU0NGWmo3Y0FTS1hsV1dTN3RUeGREOHU2OEVl?=
 =?utf-8?B?Yml2aWc3QktlQUVtQUtRblcyTllFRTZ3OVNXVWNYY0NuYTIzZVdOcXppNksv?=
 =?utf-8?B?R3Q3Q2RDVkRKNGp4em5ubTBIcjlXSUM4OHh3cXpIYmlEdG0xT0lTWFN4MldS?=
 =?utf-8?B?eXN2SWR1VDV6clAxVWI4MEtjbXZ4dmZKQ2cvcVNVTWVSay9QR3FFdXcrclRU?=
 =?utf-8?B?bWo3VjR2QlY1Ulkybm9YQm5ZYlcvSXNzUkpWQWNmQnlaQVp0eDZDekppZUhK?=
 =?utf-8?B?YytLZ2oyN2w5WDFSTE5DSEJQMVM0Qy96aElWOVplN3BRS293eFVzQ0l5UVVl?=
 =?utf-8?B?OS80QitteGFnMnFWQk5ZdWpGYi9SRVE0NTBsSU5DU1F6ejZNNGZ1eVhENkNH?=
 =?utf-8?B?UnBFRzIvL0ZsNUNSd1FuNGU1T2h5TnV1VEd1WDlRUHZqSm9XYU1xVFJIangv?=
 =?utf-8?B?MlBYQzhDZXFkTkpQWkZIMkEwTDZFZ2hIU1dBRVh5WVZCSXlyVW9rd0NjaDVO?=
 =?utf-8?B?b0g2VjVpNmJXSnY4bWtpOHFYNHZmQzJYMGorRDdaaUgzalg1aXhkVjFWNzFK?=
 =?utf-8?B?R3V4L2NIMGIvU1QrVCtjTUpqZWJhQXh2ZWlJT0JEenBLQ1BwREU0Ymt4VW1S?=
 =?utf-8?B?cG8rYWR5Vlh0VzduYm1FYkw4MVJZanQ2SFc4b21zb0NwcS9NeFF2NXJuYmpO?=
 =?utf-8?B?QzJYZDFpdzkvWnlXcWFqaFhYVW0vMDVCc3FPSENRTDY5QXdEK29YRjIxZXY0?=
 =?utf-8?B?cjQxcTh6NGIrRGFrQTk2bnZLSnFYRitwQUkwemNZV1JXTzN1SG56S05ZcmUy?=
 =?utf-8?B?c3NBaGp6WmwrQ0dOUXUrb3Uyamc0NTg0Z0crYXRSVGloWVZsMXpreWpNeEo3?=
 =?utf-8?B?SndIcCs4TFY4eW5kV28zTTNTSzdPRnFqQ3JKSHIzNnJZNncrSkw5V3BYS2l5?=
 =?utf-8?B?b0N4Tmx0Z24wMDNxei9XZHpuWTJzeHlqV0pla01MVmE4ck1sOGM5bHIwUDJP?=
 =?utf-8?B?UEVFNkhNY1gvVk1EM3dlZjFGZ1UrdWY3bm41anh2VG1lc2tvWHZld3JQOGpy?=
 =?utf-8?B?QlZTdFUrdFV5N0lxNGFsS0piRXdoRmR3TFFPZVdXVTVVbElaQ3pnSmVUZ2Rv?=
 =?utf-8?B?Sk1CVUNlV2QvaXIybkY2SFp0Z0QzcXVMbVNZbVdSN0hBM2VWQ1FyTXRFaTN0?=
 =?utf-8?B?OHpVVHBXcFNSaTIxMWpmUmwvQ01CT0duUTJwR2pZK3V4YnQ3QTQrQ1dNWUxC?=
 =?utf-8?Q?0sxAvV6lX4z+ZPTe58pHTOz++UEg5y62w9?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR04MB0963.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1a55439-68c8-4762-8206-08db23532cf7
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Mar 2023 23:40:34.6264
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: or7BJiolxEdTJ7wvsDIAWsShwpmAuvoezPvDibyTeFVbFIbUCRGnvVKlsN+0nrdGzoIlD+RZ8cFBbV+EGN9UtA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6330
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gRnJpLCAyMDIzLTAzLTEwIGF0IDA5OjExICswMDAwLCBMYXdyZW5jZSBIdW50ZXIgd3JvdGU6
Cj4gRnJvbTogS2lyYW4gT3N0cm9sZW5rIDxraXJhbi5vc3Ryb2xlbmtAY29kZXRoaW5rLmNvLnVr
Pgo+IAo+IFRoaXMgcmVmYWN0b3JpbmcgZW5zdXJlcyB0aGVzZSBmdW5jdGlvbnMvbWFjcm9zIGNh
biBiZSB1c2VkIGJ5IGJvdGgKPiB2ZWN0b3IgYW5kIHZlY3Rvci1jcnlwdG8gaGVscGVycyAobGF0
dGVyIGltcGxlbWVudGVkIGluIHByb2NlZWRpbmcKPiBjb21taXQpLgo+IAo+IFNpZ25lZC1vZmYt
Ynk6IEtpcmFuIE9zdHJvbGVuayA8a2lyYW4ub3N0cm9sZW5rQGNvZGV0aGluay5jby51az4KPiAt
LS0KPiDCoHRhcmdldC9yaXNjdi92ZWN0b3JfaGVscGVyLmPCoMKgwqAgfCAzNiAtLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tCj4gLS0KPiDCoHRhcmdldC9yaXNjdi92ZWN0b3JfaW50ZXJu
YWxzLmMgfCAyNCArKysrKysrKysrKysrKysrKysrKysrCj4gwqB0YXJnZXQvcmlzY3YvdmVjdG9y
X2ludGVybmFscy5oIHwgMTYgKysrKysrKysrKysrKysrCj4gwqAzIGZpbGVzIGNoYW5nZWQsIDQw
IGluc2VydGlvbnMoKyksIDM2IGRlbGV0aW9ucygtKQo+IApSZXZpZXdlZC1ieTogV2lsZnJlZCBN
YWxsYXdhIDx3aWxmcmVkLm1hbGxhd2FAd2RjLmNvbT4KPiBkaWZmIC0tZ2l0IGEvdGFyZ2V0L3Jp
c2N2L3ZlY3Rvcl9oZWxwZXIuYwo+IGIvdGFyZ2V0L3Jpc2N2L3ZlY3Rvcl9oZWxwZXIuYwo+IGlu
ZGV4IDgyM2FhOGViMDguLjA5Yjc5MDY1M2UgMTAwNjQ0Cj4gLS0tIGEvdGFyZ2V0L3Jpc2N2L3Zl
Y3Rvcl9oZWxwZXIuYwo+ICsrKyBiL3RhcmdldC9yaXNjdi92ZWN0b3JfaGVscGVyLmMKPiBAQCAt
NzIxLDggKzcyMSw2IEBAIEdFTl9WRVhUX1ZWKHZzdWJfdnZfaCwgMikKPiDCoEdFTl9WRVhUX1ZW
KHZzdWJfdnZfdywgNCkKPiDCoEdFTl9WRVhUX1ZWKHZzdWJfdnZfZCwgOCkKPiDCoAo+IC10eXBl
ZGVmIHZvaWQgb3BpdngyX2ZuKHZvaWQgKnZkLCB0YXJnZXRfbG9uZyBzMSwgdm9pZCAqdnMyLCBp
bnQgaSk7Cj4gLQo+IMKgLyoKPiDCoCAqIChUMSlzMSBnaXZlcyB0aGUgcmVhbCBvcGVyYXRvciB0
eXBlLgo+IMKgICogKFRYMSkoVDEpczEgZXhwYW5kcyB0aGUgb3BlcmF0b3IgdHlwZSBvZiB3aWRl
biBvciBuYXJyb3cKPiBvcGVyYXRpb25zLgo+IEBAIC03NDcsNDAgKzc0NSw2IEBAIFJWVkNBTEwo
T1BJVlgyLCB2cnN1Yl92eF9oLCBPUF9TU1NfSCwgSDIsIEgyLAo+IERPX1JTVUIpCj4gwqBSVlZD
QUxMKE9QSVZYMiwgdnJzdWJfdnhfdywgT1BfU1NTX1csIEg0LCBINCwgRE9fUlNVQikKPiDCoFJW
VkNBTEwoT1BJVlgyLCB2cnN1Yl92eF9kLCBPUF9TU1NfRCwgSDgsIEg4LCBET19SU1VCKQo+IMKg
Cj4gLXN0YXRpYyB2b2lkIGRvX3ZleHRfdngodm9pZCAqdmQsIHZvaWQgKnYwLCB0YXJnZXRfbG9u
ZyBzMSwgdm9pZAo+ICp2czIsCj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgIENQVVJJU0NWU3RhdGUgKmVudiwgdWludDMyX3QgZGVzYywKPiAtwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgb3BpdngyX2ZuIGZuLCB1aW50MzJf
dCBlc3opCj4gLXsKPiAtwqDCoMKgIHVpbnQzMl90IHZtID0gdmV4dF92bShkZXNjKTsKPiAtwqDC
oMKgIHVpbnQzMl90IHZsID0gZW52LT52bDsKPiAtwqDCoMKgIHVpbnQzMl90IHRvdGFsX2VsZW1z
ID0gdmV4dF9nZXRfdG90YWxfZWxlbXMoZW52LCBkZXNjLCBlc3opOwo+IC3CoMKgwqAgdWludDMy
X3QgdnRhID0gdmV4dF92dGEoZGVzYyk7Cj4gLcKgwqDCoCB1aW50MzJfdCB2bWEgPSB2ZXh0X3Zt
YShkZXNjKTsKPiAtwqDCoMKgIHVpbnQzMl90IGk7Cj4gLQo+IC3CoMKgwqAgZm9yIChpID0gZW52
LT52c3RhcnQ7IGkgPCB2bDsgaSsrKSB7Cj4gLcKgwqDCoMKgwqDCoMKgIGlmICghdm0gJiYgIXZl
eHRfZWxlbV9tYXNrKHYwLCBpKSkgewo+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgIC8qIHNldCBt
YXNrZWQtb2ZmIGVsZW1lbnRzIHRvIDFzICovCj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgdmV4
dF9zZXRfZWxlbXNfMXModmQsIHZtYSwgaSAqIGVzeiwgKGkgKyAxKSAqIGVzeik7Cj4gLcKgwqDC
oMKgwqDCoMKgwqDCoMKgwqAgY29udGludWU7Cj4gLcKgwqDCoMKgwqDCoMKgIH0KPiAtwqDCoMKg
wqDCoMKgwqAgZm4odmQsIHMxLCB2czIsIGkpOwo+IC3CoMKgwqAgfQo+IC3CoMKgwqAgZW52LT52
c3RhcnQgPSAwOwo+IC3CoMKgwqAgLyogc2V0IHRhaWwgZWxlbWVudHMgdG8gMXMgKi8KPiAtwqDC
oMKgIHZleHRfc2V0X2VsZW1zXzFzKHZkLCB2dGEsIHZsICogZXN6LCB0b3RhbF9lbGVtcyAqIGVz
eik7Cj4gLX0KPiAtCj4gLS8qIGdlbmVyYXRlIHRoZSBoZWxwZXJzIGZvciBPUElWWCAqLwo+IC0j
ZGVmaW5lIEdFTl9WRVhUX1ZYKE5BTUUsIEVTWinCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgXAo+IC12b2lkIEhFTFBFUihOQU1FKSh2b2lkICp2
ZCwgdm9pZCAqdjAsIHRhcmdldF91bG9uZyBzMSzCoMKgwqAgXAo+IC3CoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgIHZvaWQgKnZzMiwgQ1BVUklTQ1ZTdGF0ZSAqZW52LMKgwqDCoMKg
wqDCoMKgwqDCoCBcCj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgdWludDMy
X3QgZGVzYynCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oCBcCj4gLXvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgIFwKPiAtwqDCoMKgIGRvX3ZleHRfdngodmQsIHYwLCBzMSwgdnMyLCBlbnYsIGRlc2Ms
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIFwKPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCBkb18jI05BTUUsIEVTWik7wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoCBcCj4gLX0KPiAtCj4gwqBHRU5fVkVYVF9WWCh2YWRkX3Z4X2Is
IDEpCj4gwqBHRU5fVkVYVF9WWCh2YWRkX3Z4X2gsIDIpCj4gwqBHRU5fVkVYVF9WWCh2YWRkX3Z4
X3csIDQpCj4gZGlmZiAtLWdpdCBhL3RhcmdldC9yaXNjdi92ZWN0b3JfaW50ZXJuYWxzLmMKPiBi
L3RhcmdldC9yaXNjdi92ZWN0b3JfaW50ZXJuYWxzLmMKPiBpbmRleCA5NWVmYWE3OWNiLi45Y2Y1
YzE3Y2RlIDEwMDY0NAo+IC0tLSBhL3RhcmdldC9yaXNjdi92ZWN0b3JfaW50ZXJuYWxzLmMKPiAr
KysgYi90YXJnZXQvcmlzY3YvdmVjdG9yX2ludGVybmFscy5jCj4gQEAgLTU1LDMgKzU1LDI3IEBA
IHZvaWQgZG9fdmV4dF92dih2b2lkICp2ZCwgdm9pZCAqdjAsIHZvaWQgKnZzMSwKPiB2b2lkICp2
czIsCj4gwqDCoMKgwqAgLyogc2V0IHRhaWwgZWxlbWVudHMgdG8gMXMgKi8KPiDCoMKgwqDCoCB2
ZXh0X3NldF9lbGVtc18xcyh2ZCwgdnRhLCB2bCAqIGVzeiwgdG90YWxfZWxlbXMgKiBlc3opOwo+
IMKgfQo+ICsKPiArdm9pZCBkb192ZXh0X3Z4KHZvaWQgKnZkLCB2b2lkICp2MCwgdGFyZ2V0X2xv
bmcgczEsIHZvaWQgKnZzMiwKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIENQVVJJ
U0NWU3RhdGUgKmVudiwgdWludDMyX3QgZGVzYywKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgIG9waXZ4Ml9mbiBmbiwgdWludDMyX3QgZXN6KQo+ICt7Cj4gK8KgwqDCoCB1aW50MzJf
dCB2bSA9IHZleHRfdm0oZGVzYyk7Cj4gK8KgwqDCoCB1aW50MzJfdCB2bCA9IGVudi0+dmw7Cj4g
K8KgwqDCoCB1aW50MzJfdCB0b3RhbF9lbGVtcyA9IHZleHRfZ2V0X3RvdGFsX2VsZW1zKGVudiwg
ZGVzYywgZXN6KTsKPiArwqDCoMKgIHVpbnQzMl90IHZ0YSA9IHZleHRfdnRhKGRlc2MpOwo+ICvC
oMKgwqAgdWludDMyX3Qgdm1hID0gdmV4dF92bWEoZGVzYyk7Cj4gK8KgwqDCoCB1aW50MzJfdCBp
Owo+ICsKPiArwqDCoMKgIGZvciAoaSA9IGVudi0+dnN0YXJ0OyBpIDwgdmw7IGkrKykgewo+ICvC
oMKgwqDCoMKgwqDCoCBpZiAoIXZtICYmICF2ZXh0X2VsZW1fbWFzayh2MCwgaSkpIHsKPiArwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoCAvKiBzZXQgbWFza2VkLW9mZiBlbGVtZW50cyB0byAxcyAqLwo+
ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHZleHRfc2V0X2VsZW1zXzFzKHZkLCB2bWEsIGkgKiBl
c3osIChpICsgMSkgKiBlc3opOwo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGNvbnRpbnVlOwo+
ICvCoMKgwqDCoMKgwqDCoCB9Cj4gK8KgwqDCoMKgwqDCoMKgIGZuKHZkLCBzMSwgdnMyLCBpKTsK
PiArwqDCoMKgIH0KPiArwqDCoMKgIGVudi0+dnN0YXJ0ID0gMDsKPiArwqDCoMKgIC8qIHNldCB0
YWlsIGVsZW1lbnRzIHRvIDFzICovCj4gK8KgwqDCoCB2ZXh0X3NldF9lbGVtc18xcyh2ZCwgdnRh
LCB2bCAqIGVzeiwgdG90YWxfZWxlbXMgKiBlc3opOwo+ICt9Cj4gZGlmZiAtLWdpdCBhL3Rhcmdl
dC9yaXNjdi92ZWN0b3JfaW50ZXJuYWxzLmgKPiBiL3RhcmdldC9yaXNjdi92ZWN0b3JfaW50ZXJu
YWxzLmgKPiBpbmRleCAxZDI2ZmY5NTE0Li45MDUwMGU1ZGY2IDEwMDY0NAo+IC0tLSBhL3Rhcmdl
dC9yaXNjdi92ZWN0b3JfaW50ZXJuYWxzLmgKPiArKysgYi90YXJnZXQvcmlzY3YvdmVjdG9yX2lu
dGVybmFscy5oCj4gQEAgLTExNSw0ICsxMTUsMjAgQEAgdm9pZCBIRUxQRVIoTkFNRSkodm9pZCAq
dmQsIHZvaWQgKnYwLCB2b2lkCj4gKnZzMSzCoMKgwqDCoMKgwqDCoMKgwqAgXAo+IMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBkb18jI05BTUUsIEVTWik7wqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBcCj4gwqB9Cj4gwqAKPiArdHlwZWRl
ZiB2b2lkIG9waXZ4Ml9mbih2b2lkICp2ZCwgdGFyZ2V0X2xvbmcgczEsIHZvaWQgKnZzMiwgaW50
IGkpOwo+ICsKPiArdm9pZCBkb192ZXh0X3Z4KHZvaWQgKnZkLCB2b2lkICp2MCwgdGFyZ2V0X2xv
bmcgczEsIHZvaWQgKnZzMiwKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIENQVVJJ
U0NWU3RhdGUgKmVudiwgdWludDMyX3QgZGVzYywKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgIG9waXZ4Ml9mbiBmbiwgdWludDMyX3QgZXN6KTsKPiArCj4gKy8qIGdlbmVyYXRlIHRo
ZSBoZWxwZXJzIGZvciBPUElWWCAqLwo+ICsjZGVmaW5lIEdFTl9WRVhUX1ZYKE5BTUUsIEVTWinC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgXAo+
ICt2b2lkIEhFTFBFUihOQU1FKSh2b2lkICp2ZCwgdm9pZCAqdjAsIHRhcmdldF91bG9uZyBzMSzC
oMKgwqAgXAo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHZvaWQgKnZzMiwg
Q1BVUklTQ1ZTdGF0ZSAqZW52LMKgwqDCoMKgwqDCoMKgwqDCoCBcCj4gK8KgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqAgdWludDMyX3QgZGVzYynCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBcCj4gK3vCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIFwKPiArwqDCoMKgIGRvX3ZleHRfdngo
dmQsIHYwLCBzMSwgdnMyLCBlbnYsIGRlc2MswqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
IFwKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBkb18jI05BTUUsIEVTWik7wqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBcCj4gK30KPiAr
Cj4gwqAjZW5kaWYgLyogVEFSR0VUX1JJU0NWX1ZFQ1RPUl9JTlRFUk5BTFNfSCAqLwoK
