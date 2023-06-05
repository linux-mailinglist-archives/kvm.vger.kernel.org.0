Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49930722CD4
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 18:39:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230030AbjFEQj2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 12:39:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229974AbjFEQj0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 12:39:26 -0400
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35E7CD2;
        Mon,  5 Jun 2023 09:39:25 -0700 (PDT)
Received: from pps.filterd (m0127841.ppops.net [127.0.0.1])
        by mx0b-002c1b01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 355F5Bqw000400;
        Mon, 5 Jun 2023 09:39:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version;
 s=proofpoint20171006; bh=4QQPma7cNTqo3HoL18/PK818eVcuLo+Ddb3BFeOpwQE=;
 b=v0DQ93HMAzyC0PwehS6iEy3Dln5e8P8x0xrWA7Esys5YPJ5nn1lmxGvLvh8T1J3Wc0F8
 i+u5nfuv9VGV4Gfc2lMeKx396WTQuc0hojpYRgh9nR7txQ9LM5qlhGOOoZo4M0s4EBvc
 I8Z9Fj8jpOi5PRJ1O5IbUV6dwAD9DZR2zL8mo8HRScYbtppnfETSMU+IbfxSentoOsgc
 jgIMZmQjlTZ+7Z1OHha/wwQUPGYZVKlaclNrKwXHmQ2U+i1t5WUUHPj6NBDZN/g8oE3Y
 i9XuAPa2etU1Jxw6C4dntYEyUepGLCvQmORrPnqDFaWI+Nen3B8IzIucNj383krFJBuW Tw== 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2107.outbound.protection.outlook.com [104.47.58.107])
        by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 3r0326uqhf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Jun 2023 09:39:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jg5pIggddJOScxgug8vvUtnLoJcCbftBj8pl4SNpRxFuaZKUqcnO+oIaPDM5u7aJ7U8FuLxs7h5UjGyhDmduevCMBR9aDrXRokGhaeSbh52zzMBcK7bO706eB6nUg7zUXioxwfiMrbObBB5VOIFMVJjSgikUKyFfUgcfPAzox7yMGQNyhmTRRyoWeMYMPFxh6O90YgRw7q6AmSU3YRwmWS0iZ6ctYVub70ESremdyTeDX9elQT/ZSL082djpfTsXm8bYcYsPG7nviVBeheXG3Hs0rtpEvUBk/hmRoByBkBzxCyzW2jhQ18xid8P5RCs3sZcwWsPXShbTu06Ot6mL9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4QQPma7cNTqo3HoL18/PK818eVcuLo+Ddb3BFeOpwQE=;
 b=m1ZaPhDG3RAgUURT/bgR8jXoNcqQVQh8D+5GxmyK1Bdlu4y0S6FTmLWpVgymqhy7goUmcr/o8SHaQoPW+LhLXQzFW3BXx1vJITue1+bmA1vGAI1llR2Bf62L0O+OX+QVUb2dTpxURTFnDV9DZdPGinIszIYUffosraV/r5u7Fzj7jl0iLwwSBB6XNUIKMJwTXmI2NIxxQsqn/aoP/k47L8hgMiTIksjeIGm9jMqOfDuZH/ptvgCV7AV+b4POLpEr7Ho6UmWCW1cxMAe9GnzW/od2za7g8a1X+FwGwOarRM4Dmru8Cd9IERD5Jlph2IGWyGmXrDzfjpn9R+Luk90sYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4QQPma7cNTqo3HoL18/PK818eVcuLo+Ddb3BFeOpwQE=;
 b=lZkesR8e7jd8I0/J6WuGIr8Pby49MEA+Lq9DVYUQ+giXg8257n/Z020b3FW/J+JKowhijOB+n/sk8jfd/L2WvcFkMK73VtSOQUJ2XQUSptHPsrrcFSf2V/rXeFWXejrAhu4nN1RCTzZGAgqIXn04PKanYO4cCJihGPcSry8CejO0OxK8VsW05Ee25cYCugc6pYzAvvC9YU+WR4Acfu+B1wjFfV+LmhkiZViyhhfOgizhNV6sgIEg8DNFhTioMirNGzrgulhhqG/WPqhbg4XN7fgh1Rr0Nze6rxkpOhrd+Zak75j/BsowS90LbAsoAbas3N7g1eqhirf988aw4NPP3A==
Received: from DM6PR02MB4585.namprd02.prod.outlook.com (2603:10b6:5:28::17) by
 IA1PR02MB9493.namprd02.prod.outlook.com (2603:10b6:208:3fd::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Mon, 5 Jun
 2023 16:39:02 +0000
Received: from DM6PR02MB4585.namprd02.prod.outlook.com
 ([fe80::e48f:7318:a1cf:dbf1]) by DM6PR02MB4585.namprd02.prod.outlook.com
 ([fe80::e48f:7318:a1cf:dbf1%4]) with mapi id 15.20.6455.030; Mon, 5 Jun 2023
 16:39:02 +0000
From:   Jon Kohler <jon@nutanix.com>
To:     Josh Poimboeuf <jpoimboe@kernel.org>
CC:     Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        "kvm @ vger . kernel . org" <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: VMX: remove LFENCE in vmx_spec_ctrl_restore_host()
Thread-Topic: [PATCH] KVM: VMX: remove LFENCE in vmx_spec_ctrl_restore_host()
Thread-Index: AQHZk9DFtRNtW0r2UU2DHIN38zEv2a91BL4AgAALIICAAAxDAIAAAnMAgAAJaYCAADIWgIAG8nEAgAAjbwCAAADigA==
Date:   Mon, 5 Jun 2023 16:39:02 +0000
Message-ID: <E704D6D6-3B03-40FA-8CDB-5FB58871BABC@nutanix.com>
References: <20230531150112.76156-1-jon@nutanix.com>
 <20230531231820.trrs2uugc24gegj4@treble>
 <F4BEBCAF-CBFC-4C3E-8B01-2ED84CF2E13A@nutanix.com>
 <20230601004202.63yulqs73kuh3ep6@treble>
 <846dd0c5-d431-e20e-fdb3-a4a26b6a22ca@citrix.com>
 <20230601012323.36te7hfv366danpf@desk>
 <20230601042345.52s5337uz62p6aow@treble>
 <21D1D290-7DE9-4864-A05B-A36779D9DC26@nutanix.com>
 <20230605163552.hi5kvh5wijegmus6@treble>
In-Reply-To: <20230605163552.hi5kvh5wijegmus6@treble>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.1)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR02MB4585:EE_|IA1PR02MB9493:EE_
x-ms-office365-filtering-correlation-id: a33d10bd-170c-42fd-c7a5-08db65e35ea8
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Yv2ZjA6BAQWk1kUKbukdwAnGS61XOw6AYHXK1FDbbMQTk8LY2YZnyyezAv+fzrN9TM1d4ZAc8Yg8XVt7tSDgxKDvlD9qKReqNN83Cut+bRzvKsklKJrph28PIAogKCOMzHJNxd0bvZrUVIk5Dbl5HDjRQM3g+xgimscLPQ0xcgFoYRQ3zm95E9/i4B5hbavBsljwl5vLvbEJW7/Luq7fG6iw8+VeBmlM6U6+8weCiZTnQh2PJEAuDrAe0+SScJQSsDNUd3hppe18ySS3X65Pu7NDhVWu7EqexEuCFA0H5kZixChiJnwKRb7T+9JRpX9LjD5ANjIaQl3iR7/W27SFYkeKvi9zV0D91g0v35aQqelW0M1KYsewZNjvl3z63fzSn8jyNughhpk/MATpOOhA2smdcVsJAhSTnqHKnQVqT+lVC854xOWso4NkoIb0XtPrECbJFIX90zdnYCOSJa9ntPb/hmpsLT0Kp63w+U0CNsFwHAkjTkycuCnnIUZPsR9kOHCn0SaeuPDitp2z87XpQoD7vZmOyMP9TLlxgxqwbm8uecl/pQ1xUawUX++fxqQduwsaDeltnkPRjRB4FTKRGtoaz5J7zsBFjwnHXOoVbBx9yJqmkiCZXppEP5J1fftJS2ThmLf4CWmzP9GRckIIVQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR02MB4585.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(39860400002)(346002)(366004)(376002)(136003)(451199021)(54906003)(71200400001)(478600001)(5660300002)(8676002)(8936002)(7416002)(36756003)(38070700005)(2906002)(86362001)(33656002)(4326008)(6916009)(91956017)(122000001)(66446008)(66556008)(64756008)(66476007)(66946007)(316002)(76116006)(38100700002)(41300700001)(83380400001)(6506007)(6512007)(53546011)(2616005)(186003)(6486002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RWYremZpN01IbUhnU3FReTFVR2ZQaUVMR0M1Y05NWWpNVkxycW12bUNOWHRF?=
 =?utf-8?B?YnltMlhmaHZDTXVadWQ4NyszNTNVQ0FFeHFialFkU3VyMGVoa3JoaGVNdm9H?=
 =?utf-8?B?aHBuU3V0M0FqempVUGR4TnpyQnJ2bnBqSUN2MGhJVk50bWlUNXVRbjQ5dnJT?=
 =?utf-8?B?T0NDUitjeVdsWWlYS0EzbDRMWWU3akd3YUVNM0x6NU0wSWR3MU43SnZJUUNO?=
 =?utf-8?B?dGY4cmZ0c1RTWFNKQkNRWDB0SFJpK3hldFhrL0lLQnBjTHlmL3pXYmNpaThD?=
 =?utf-8?B?WW1QWTlYOGUxVndLMUNxRk10alYvYk01dFVvZ0V2a3JaaUJ6RnozNGxGVnRN?=
 =?utf-8?B?cUhNZFVvVVBuSmR2c0ZKSUJiekR3dWk0YU01RVBvSElNVlpvaGJaSk9IU3Jm?=
 =?utf-8?B?QjNNcTZOSjE2MVJyNUJOZlFpSlhNTFlDL3RNdnp3a1VoV1JkQWE1UkVNMmYz?=
 =?utf-8?B?ZlpnUngwMkQ2N3VScVY0dFlOZE9EMTVKcmI2UXJwcVZHNk1jZVlPaGExRU5y?=
 =?utf-8?B?N2txem1OZGZ4YTZwUDViM1JGeVFCSEdqcnRZbURNVnhLUVJNRVd5TTJJNE9Z?=
 =?utf-8?B?R09xOXNVZndyMWx4MDZFWko0RjhWNzFhWU5POUUrVXQxR1NGMzRHbHpGeElr?=
 =?utf-8?B?eXA1RDhzdUdHcG9UaDRuV01COVErR0tObXRVRTVZUUppN0l0Z210VVloQzkx?=
 =?utf-8?B?L1NVM0xucnk5NytTcm9qU0VlNGhWUWVqZWRwcVdoNmdpV296VzdYNStsaHdm?=
 =?utf-8?B?bDdtTU5ScVBsS3VLQ1QzWmtoeW04TUJiVXN2cERERHU3N2F0WFVwYXQ5clA1?=
 =?utf-8?B?c0JMM0lSQUNYRXRhUUloMDFtUG42aGtxVGZzTGN5K250MWFIdjYycUphRmRL?=
 =?utf-8?B?elY5YXR6cGhmWW5OMTJFRzNIVldKZ0xxTGtDZmFSQk9hU2Q5QWhpakROU3BT?=
 =?utf-8?B?RHZuRkNXK2tnelBmcnp6NnFObjB5eWdXZFRhU0JCOVcvL2Y0czQxajBBVDM2?=
 =?utf-8?B?ZnZuV1pJUzFBMTk0T1NRWGQyVjhTcUxZOGFoTWdraXRUajhqV2pDOGZWdjNu?=
 =?utf-8?B?b2drV2Z6WHhqOUI4Y2Vmd3RieThsZS9xWUZRUzRsTVRwUlhsWTQwVWFKbWpQ?=
 =?utf-8?B?Zmh2SnRuNWZyY3JFdzBxK0tsbzF4YlgzeXFPOEhucDg2NmwxTHVjV3M5SkZB?=
 =?utf-8?B?RHMvK0R0c0s3RkxuWjk0S2NjdTlrUVpGcGp0UVE3dGtaY1BKL1dUdjkvQlJu?=
 =?utf-8?B?cUl6Rmx4ZkZHZ3RLVTEzdlNDK1BYMFd2alVoQ0dFazlFOFdlWld6K1k4bHVu?=
 =?utf-8?B?WVRQdURwb0R5Q0tmWEFNblFJWVdIKzZCTlM0MDA1YURTbWZPYTRvZUhEdzky?=
 =?utf-8?B?akpjYjZWM1o3ZGY4MGljUTBhbEZ1T0tCcDcrUmVndlo4NzVUYzk3ZVdtL3dB?=
 =?utf-8?B?RytlSEQzUFJoRTNsa1N1Q3NCV1dUUGwxS3R1SnVjMVJ4Q0FUb05oRE8vMldx?=
 =?utf-8?B?elZzWVBXMEY2QnVPL2pZcUNtVHZUcXBMczlnT3E2eUpGOXRyTjI4ZFRQTStZ?=
 =?utf-8?B?VTYvK1JwVGJlMWhJSlhTditTZ2tEYWgvbWJzQTl6OG1xVHlaMlUvYUw1SkV6?=
 =?utf-8?B?bXMwUTJmVnVjTzRuREhRemtnc2MvOWx3L2ZLcWw4U01HNy9IZ2hOOGVYWTdh?=
 =?utf-8?B?aTE0and0MCtibklNZWNnYWluWHgxbmRZRGtQbUNPNFowMkdKNXk2SzlWTU95?=
 =?utf-8?B?OWQ5Qy8vRU9lRkZDVUpYY0JvWnJrU052b2V5K29odVRyRU0zc25DeDFXRkV4?=
 =?utf-8?B?V25LbFlyaXl6S3FOY0haYzBjL1IvaWR2Ukp2VlkrN3k5MmI0RWxZUFNNakpI?=
 =?utf-8?B?RDAwL3NJbSsrUERzZkVyMW41cUEwL1RkY2o0R25UamF6WS9EaFd0M0ljS0Vr?=
 =?utf-8?B?S2h4M1JjMFpyQW5kTjhHYXc4aFZIYW9Mb0gxQkxYSExTUlJPZTh1UHVtOUlY?=
 =?utf-8?B?bTBSbkFOYUo0ZmZySTVZa0dFOGJTbllTNmtMNlpZdUNsaTBWOGE3TUlnWUZs?=
 =?utf-8?B?c3dRdUl5cHdBQWxhREV3cGZ6d0NRanNSU3hUOHNhSEVBVDN2aVFZbkRMYmhO?=
 =?utf-8?B?M21LTE9aT29XbHBMVXA5ZkY0RlBtVlYvazc1cTdPNEFSd0k2dmYwd3U4NXBE?=
 =?utf-8?B?OG5odWZJdmo5cU5EZ1E5VFdGUi9sNndQQU0zYmp6ZEdycFREcWk5YnV1S2Fi?=
 =?utf-8?B?N3NrRzZIbzZpbllVL1ROVEtSTDJRPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <480FDB70BE9EBA448845B834A3739F19@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR02MB4585.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a33d10bd-170c-42fd-c7a5-08db65e35ea8
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jun 2023 16:39:02.2861
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: APTgjFmZgNpV9M0oduk/JFuIEEj6UhvJb9B4ArwMJxvkNoe0MR0EhxyAjr8g11ohiheWGmj3WsJwmQL5H/Ew+PCSMb1knFznughJ30ZRSco=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR02MB9493
X-Proofpoint-GUID: QUSKdDwXWsCSZjM-EDbYFANCaCgTLMrB
X-Proofpoint-ORIG-GUID: QUSKdDwXWsCSZjM-EDbYFANCaCgTLMrB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-05_31,2023-06-02_02,2023-05-22_02
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gT24gSnVuIDUsIDIwMjMsIGF0IDEyOjM1IFBNLCBKb3NoIFBvaW1ib2V1ZiA8anBvaW1i
b2VAa2VybmVsLm9yZz4gd3JvdGU6DQo+IA0KPiBPbiBNb24sIEp1biAwNSwgMjAyMyBhdCAwMjoy
OTowMlBNICswMDAwLCBKb24gS29obGVyIHdyb3RlOg0KPj4gDQo+PiANCj4+PiBPbiBKdW4gMSwg
MjAyMywgYXQgMTI6MjMgQU0sIEpvc2ggUG9pbWJvZXVmIDxqcG9pbWJvZUBrZXJuZWwub3JnPiB3
cm90ZToNCj4+PiANCj4+PiBPbiBXZWQsIE1heSAzMSwgMjAyMyBhdCAwNjoyNDoyOVBNIC0wNzAw
LCBQYXdhbiBHdXB0YSB3cm90ZToNCj4+PiANCj4+PiAjIyAyMDIzLTA1LTMxDQo+Pj4+IE9uIFRo
dSwgSnVuIDAxLCAyMDIzIGF0IDAxOjUwOjQ4QU0gKzAxMDAsIEFuZHJldyBDb29wZXIgd3JvdGU6
DQo+Pj4+PiBPbiAwMS8wNi8yMDIzIDE6NDIgYW0sIEpvc2ggUG9pbWJvZXVmIHdyb3RlOg0KPj4+
Pj4+IFNvIGVhY2ggTEZFTkNFIGhhcyBhIGRpc3RpbmN0IHB1cnBvc2UuICBUaGF0IHNhaWQsIHRo
ZXJlIGFyZSBubyBpbmRpcmVjdA0KPj4+Pj4+IGJyYW5jaGVzIG9yIHVuYmFsYW5jZWQgUkVUcyBi
ZXR3ZWVuIHRoZW0uDQo+Pj4+PiANCj4+Pj4+IEhvdyBsdWNreSBhcmUgeW91IGZlZWxpbmc/DQo+
Pj4+PiANCj4+Pj4+IFlvdSdyZSBpbiBDIGF0IHRoaXMgcG9pbnQsIHdoaWNoIG1lYW5zIHRoZSBj
b21waWxlciBjb3VsZCBoYXZlIGVtaXR0ZWQgYQ0KPj4+Pj4gY2FsbCB0byBtZW17Y3B5LGNtcH0o
KSBpbiBwbGFjZSBvZiBhIHNpbXBsZSBhc3NpZ25tZW50L2NvbXBhcmlzb24uDQo+Pj4+IA0KPj4+
PiBNb3ZpbmcgdGhlIHNlY29uZCBMRkVOQ0UgdG8gdGhlIGVsc2UgcGFydCBvZiBXUk1TUiBzaG91
bGQgYmUgcG9zc2libGU/DQo+Pj4+IFNvIHRoYXQgdGhlIHNlcmlhbGl6YXRpb24gY2FuIGJlIGFj
aGl2ZWQgZWl0aGVyIGJ5IFdSTVNSIG9yIExGRU5DRS4gVGhpcw0KPj4+PiBzYXZlcyBhbiBMRkVO
Q0Ugd2hlbiBob3N0IGFuZCBndWVzdCB2YWx1ZSBvZiBNU1JfU1BFQ19DVFJMIGRpZmZlci4NCj4+
PiANCj4+PiBZZXMuICBUaG91Z2ggaW4gcHJhY3RpY2UgaXQgbWlnaHQgbm90IG1ha2UgbXVjaCBv
ZiBhIGRpZmZlcmVuY2UuICBXaXRoDQo+Pj4gd3Jtc3IrbGZlbmNlLCB0aGUgbGZlbmNlIGhhcyBu
b3RoaW5nIHRvIGRvIHNvIGl0IG1pZ2h0IGJlIGFsbW9zdA0KPj4+IGluc3RhbnRhbmVvdXMgYW55
d2F5Lg0KPj4+IA0KPj4+IC0tIA0KPj4+IEpvc2gNCj4+IA0KPj4gQ29taW5nIGJhY2sgdG8gdGhp
cywgd2hhdCBpZiB3ZSBob2lzdGVkIGNhbGwgdm14X3NwZWNfY3RybF9yZXN0b3JlX2hvc3QgYWJv
dmUNCj4+IEZJTExfUkVUVVJOX0JVRkZFUiwgYW5kIGRyb3BwZWQgdGhpcyBMRkVOQ0UgYXMgSSBk
aWQgaGVyZT8NCj4+IA0KPj4gVGhhdCB3YXksIHdlIHdvdWxkbuKAmXQgaGF2ZSB0byBtZXNzIHdp
dGggdGhlIGludGVybmFsIExGRU5DRSBpbiBub3NwZWMtYnJhbmNoLmgsDQo+PiBhbmQgdGhhdCB3
b3VsZCBhY3QgYXMgdGhlIOKAnGZpbmFsIGxpbmUgb2YgZGVmZW5zZeKAnSBMRkVOQ0UuDQo+PiAN
Cj4+IFdvdWxkIHRoYXQgYmUgYWNjZXB0YWJsZT8gT3IgZG9lcyBGSUxMX1JFVFVSTl9CVUZGRVIg
Km5lZWQqIHRvIG9jY3VyDQo+PiBiZWZvcmUgYW55IHNvcnQgb2YgY2FsbHMgbm8gbWF0dGVyIHdo
YXQ/DQo+IA0KPiBJZiB3ZSBnbyBieSBJbnRlbCdzIHN0YXRlbWVudCB0aGF0IG9ubHkgdW5iYWxh
bmNlZCBSRVRzIGFyZSBhIGNvbmNlcm4sDQo+IHRoYXQgKm1pZ2h0KiBiZSBvayBhcyBsb25nIGFz
IHRoZXJlJ3MgYSBuaWNlIGNvbW1lbnQgYWJvdmUgdGhlDQo+IEZJTExfUkVUVVJOX0JVRkZFUiB1
c2FnZSBzaXRlIGRlc2NyaWJpbmcgdGhlIHR3byBwdXJwb3NlcyBmb3IgdGhlDQo+IExGRU5DRS4N
Cj4gDQo+IEhvd2V2ZXIsIGJhc2VkIG9uIEFuZHkncyBjb25jZXJucywgd2hpY2ggSSd2ZSBkaXNj
dXNzZWQgd2l0aCBoaW0NCj4gcHJpdmF0ZWx5IChidXQgSSdtIG5vdCBxdWFsaWZpZWQgdG8gYWdy
ZWUgb3IgZGlzYWdyZWUgd2l0aCksIHdlIG1heSB3YW50DQo+IHRvIGp1c3QgY29udmVydCB2bXhf
c3BlY19jdHJsX3Jlc3RvcmVfaG9zdCgpIHRvIGFzbS4gIEJldHRlciBzYWZlIHRoYW4NCj4gc29y
cnkuICBNeSBvcmlnaW5hbCBpbXBsZW1lbnRhdGlvbiBvZiB0aGF0IGZ1bmN0aW9uIHdhcyBhY3R1
YWxseSBhc20uICBJDQo+IGNhbiB0cnkgdG8gZGlnIHVwIHRoYXQgY29kZS4NCj4gDQo+IC0tIA0K
PiBKb3NoDQoNClJFIEFTTSAtIHRoYXTigJlkIGJlIG5pY2UsIGdpdmVuIHRoYXQgdGhlIHJlc3Rv
cmUgZ3Vlc3QgcHJlLXZtZW50cnkgaXMgbm93IEFTTSwNCndvdWxkIG1hdGNoIG5pY2VseS4gVGhl
biBhbGwgdGhlIGNvZGUgaXMgaW4gb25lIHNwb3QsIGluIG9uZSBmaWxlLCBpbiBvbmUgbGFuZ3Vh
Z2UuDQoNCklmIHlvdSBjb3VsZCBkaWcgdGhhdCB1cCBzbyB3ZSBkaWRu4oCZdCBoYXZlIHRvIHN0
YXJ0IGZyb20gc2NyYXRjaCwgdGhhdOKAmWQgYmUgZ3JlYXQgKGltaG8pLg0KDQpKb24NCg0K
