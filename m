Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D9C35588BC
	for <lists+kvm@lfdr.de>; Thu, 23 Jun 2022 21:27:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230192AbiFWT1D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jun 2022 15:27:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230509AbiFWT0n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jun 2022 15:26:43 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9FDB2BF3
        for <kvm@vger.kernel.org>; Thu, 23 Jun 2022 11:45:33 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25NHuniw019988
        for <kvm@vger.kernel.org>; Thu, 23 Jun 2022 11:45:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : cc : subject :
 date : message-id : references : in-reply-to : content-type : content-id :
 content-transfer-encoding : mime-version; s=facebook;
 bh=PbUiLVZXpMm2HAw5ifNPqWhakt4gtlecfYY1rzkYYg4=;
 b=g8XE3lWnq/0K+B5nQDARQchQUIYXRBhKdfvIUDKLEJu1JHjThmUQz2nhFOE0Oa7S7EQO
 H1P+qWq7zrfVcdpVCtJFbNpfUGa7PYbOi4rmwvJCdEUiECPZ4WlGkUt5NhgSTXVbEJJm
 fY5Mt7kk8kTBYaD0FC9g4rUR148iNNiXX7c= 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gv2nat1ea-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 23 Jun 2022 11:45:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fcEUmqa8lDPoyQISMPlbZLx/wIMKgM7Qm9HJMSMF6pqClSMK9PZp2CIDTqWqebXE3PaP6TSEGd0NeVHN3FDuar6RKRrndVh6sXcgaCVRWhkPpfHI35ZX3VfIIecD6VZhLZgyIh1vlJU6PsCah3ymJLUbpjd0N6rNjbWWxeOKUiwMgGppZAkoW+WeIOGyQxuH0V7XVjg0ZIsuwcBVQAUqbz1KZc3WuQwPQ2Pm0TkcUyv0u0qVaeuIFKSBk3JdLnQHu/hSRO8TSPP+FMeMIEkun8kDk/oWU/MAyx0CPOGtAnFBcm0lj9HdXTh7zEhZdtHFpBKaxw4oAjFxWeiHai5hhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PbUiLVZXpMm2HAw5ifNPqWhakt4gtlecfYY1rzkYYg4=;
 b=Gxzv1629r/iBZcypOPle9Cqk505uB1pVMrWjyA3NlV4JCYeECxG6chXX1CY5JJqDKHO+BDOFbLCA0i2BIkkS1vGJjtW77ZMQ5eXxoxJA6TzerQ2YXq+wUVK/cc3XMwOpYjQd+CUSeLVHoc01xPTlw2aezF1rpbLhC56Y+bskeAIjhY4o2Jn/PAF0UMzsHw6Q+wUVsiNiiE5IdB8heJbmeBojBr6WJIlUMkFoXHNnDbU5Pa3PLLS1ZtkEi9erTy7wYU50df7xbM/nChryjINL91AmlsMzcLB9h7VdnMrbm7i0SYBq8O6jpUti27Zh7oSUsmvtOLtDyXpMOajwpXOtFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from BYAPR15MB3032.namprd15.prod.outlook.com (2603:10b6:a03:ff::11)
 by SA1PR15MB5046.namprd15.prod.outlook.com (2603:10b6:806:1d9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15; Thu, 23 Jun
 2022 18:45:30 +0000
Received: from BYAPR15MB3032.namprd15.prod.outlook.com
 ([fe80::70d0:8133:42cc:f134]) by BYAPR15MB3032.namprd15.prod.outlook.com
 ([fe80::70d0:8133:42cc:f134%6]) with mapi id 15.20.5373.016; Thu, 23 Jun 2022
 18:45:30 +0000
From:   Peter Delevoryas <pdel@fb.com>
CC:     Peter Delevoryas <pdel@fb.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Andrew Jeffery <andrew@aj.id.au>,
        Joel Stanley <joel@jms.id.au>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "berrange@redhat.com" <berrange@redhat.com>,
        "eduardo@habkost.net" <eduardo@habkost.net>,
        "marcel.apfelbaum@gmail.com" <marcel.apfelbaum@gmail.com>,
        "richard.henderson@linaro.org" <richard.henderson@linaro.org>,
        =?utf-8?B?UGhpbGlwcGUgTWF0aGlldS1EYXVkw6k=?= <f4bug@amsat.org>,
        "ani@anisinha.ca" <ani@anisinha.ca>,
        Cameron Esfahani via <qemu-devel@nongnu.org>,
        qemu-arm <qemu-arm@nongnu.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        =?utf-8?B?Q8OpZHJpYyBMZSBHb2F0ZXI=?= <clg@kaod.org>
Subject: Re: [PATCH 08/14] aspeed: Replace direct get_system_memory() calls
Thread-Topic: [PATCH 08/14] aspeed: Replace direct get_system_memory() calls
Thread-Index: AQHYhv4La4CriQU2mky/EBXWx4tOSK1c87yAgAAtGQCAADQAgA==
Date:   Thu, 23 Jun 2022 18:45:30 +0000
Message-ID: <2ABE36FF-E631-4075-A17B-A0E1B9503238@fb.com>
References: <20220623102617.2164175-1-pdel@fb.com>
 <20220623102617.2164175-9-pdel@fb.com>
 <CAFEAcA9GAr=Rv9GMsnUux3_PNk1gRPBOcSyPzD9MRP5UzOZO1Q@mail.gmail.com>
 <6b7975b5-754b-c2d8-a46f-93a6f1827c66@kaod.org>
In-Reply-To: <6b7975b5-754b-c2d8-a46f-93a6f1827c66@kaod.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a5d65ae9-3932-49f3-af62-08da55488c3f
x-ms-traffictypediagnostic: SA1PR15MB5046:EE_
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /fct4ar0vNG8Cm+6NBQszzLRrBOZOSGFcrHx9K8wkCmvgCAiHyGp3IB7Se08JSTq+5ZP7eDR6NaPb93A1rGqZwBlpUdmXFz2aXrDvcx0IwldAoPtcioKs/s1b8QlmWJzVx5Kz6N1WIY5MTkG+cw8/9kWayZ1Fc04laQEh353eUjAJQanEnUQO6F3GZLjX6CGHUq7rZlGzKCtd6xp1yfaH0wwxcGi/XQFPzFeCzsxY9d3c1I/poZUJTm8UGNO9d2KMIr4A4LcKM7EWr3BJYeQcijfoOvR64WafGEmPQ+7QNp3ZSd0vZu4/nMvCKWo1rhyvBN7ApIMMtWBRENTHbgOffcqNpqm+Jcuk8iKGtld0oty7GFtlzO9mhCLwpBOOTfWbELmuLQWL8fkNih0eVc7J8p1fsobVFXsI0pjAcNGlQKLN8exyTVyIykZw0OXmy+kbcstO2lBoaKU+ruX9JnApcx6YywBoQGtCWowuoxfbtc1XloIfXy2FGzWfdk6b2Hw9dksOUEtErLYYDKd3rPbAWnJx9avWSBNs5Oq6vyZ654oCk5yfB/rYUPXgGP83rRNiuTDw1J3B92F7y9VF+SS1C7t57KWvtUAhEmfEPXo1EgdbBwj1xNWZ51WntDkvGETCFUky0iEwZxtkwSn8bYoziIK++yx8oeI4IuORbGwC3RG7/rjI5h0ZxQERvyX3VEmPKpVZigIN3eJeGxG2Cdp6q00gG1CjRA12U5LrflUYGm4X1eQIGQMcfqyoDDvF8VwVDaedC63WXNMXp5gUYP9Rx4IaGuqGTyDCwR0HPPEmdymFq1cU6n+Zpi/aTZ+7woMCEBo7jJ/tcihQ2UFjszJGA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB3032.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(136003)(346002)(39860400002)(366004)(376002)(83380400001)(186003)(109986005)(2616005)(71200400001)(66574015)(38100700002)(7416002)(122000001)(5660300002)(8936002)(38070700005)(8676002)(64756008)(66556008)(6486002)(41300700001)(66946007)(2906002)(478600001)(54906003)(6506007)(53546011)(76116006)(6512007)(33656002)(4326008)(66446008)(66476007)(316002)(36756003)(86362001)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QlhlZ04xQ3YxZnN4QXFuVURKVTdmamQ2eGY0SklDWUhkMjhQRVpKd1NqZTBi?=
 =?utf-8?B?SjFQZ3lPcTZ3cUhhQU5mTlNaQWU0eHVER3JnWCtNeWIwZld3cEdMaUI4ZUdS?=
 =?utf-8?B?Q2tsYjZVaDFiNDQ0MGhrSWs2QmY2K2k1RkgyWmJ1WXRCRDY3RkQ2MDRpNTcw?=
 =?utf-8?B?WS9VRExPVjJqNUlZeEN1My9LdlcwSkVuSTZIL0JJZlpsQ0RocmNqdXp4SVFt?=
 =?utf-8?B?SmJvekJYOUpQZGpIWW5Jbi9vRWs2eENXd1Evajh4RS93NW50OEM3VGFPK1VV?=
 =?utf-8?B?YTNNSTNoVUpMTUlZK2VWbUpvK3M1V0oycVZGV0lEbjdaU1lZV01EWFhaeVo1?=
 =?utf-8?B?UEYwYzU2ZHlPRWo1VE11bVNhWnBaYXJCdkIzVytMZ0FqL2RBb0JtZzVaUkN5?=
 =?utf-8?B?ekkrcHJhWW9oWDhZWnRaVEFRdU9QYmMwby9iRmloKy9ObWVxYWY5aThUWHJx?=
 =?utf-8?B?Sk9jVE5LdkFWeXJ6bTg4VGI5R2tBb1VkaWUrWnhBa3ByajQ5UE1FZVJvNFBp?=
 =?utf-8?B?WGFQZVcxMklsWHFISE95d0NPMCtFUDRIYm8wS0lCT3BkZ3BSa3NpYWRJdXBh?=
 =?utf-8?B?dTM0eTU2bUJ2SlZuclFlcUw3NWtVS1ptVDRBWlVkSjlTdEkxQnMwMVd5aWFU?=
 =?utf-8?B?K29pazZNTVJRYjBCaTh4RGxJWmttdTRZeUFEL3NocnhQcWZZOHBZQXlHQkQ4?=
 =?utf-8?B?SWMySi9ZdkR6OGZCUzVpWllBeThIUU9iaUNOak16d29lbjlMV0cxUjZUalJJ?=
 =?utf-8?B?VmxKQXNFN1QrSHF5YUVLQ1lBSVlXYlFoUU5DeEhkNXhiTXFkanRFTVZTM3pH?=
 =?utf-8?B?Mnk0WS92d0ljNUE1Z012SW4vZGQvYTlQeWl3ZXZNNWY3M3czWFhjak5VTnBh?=
 =?utf-8?B?Tk9ieWE0UEhWbFRESUhTc3hvWXN0Q0RjWEdkaUtEejM5SEladjFtKytLMmdn?=
 =?utf-8?B?L291UzBZY0NzUWJ5aUhxVW9Db2h4SzkxQk1XSkNDL0hETUU2VWgrbFZPWlZH?=
 =?utf-8?B?eThoNnNZMXFyUHFJa08ySjV0a3YzLzFRQVozQWpkN3lqZnc1LyttNFI3aVlK?=
 =?utf-8?B?Z3p4VExaNlpmcUZUTS95YnlhdXROWWJNc3FVakdidkJCa1ZiOWorUjFWMXll?=
 =?utf-8?B?aDFvaGR6OS9iQ09ydWlSTkpRK29NclllT3dBNmp4bmtjRCtpZ1pNanBzODFo?=
 =?utf-8?B?Y0RPaDkzRVFBTTlGd2loVXltOUt6THROckVaV2VlZlEyVXRVbXdxdUxsaW1F?=
 =?utf-8?B?c3RDcEcxTlhabUhPMDl1YWRqZFhDaEQwUEV1M2x3dlhnY0hOb09Tb09hTGs4?=
 =?utf-8?B?Q09MRkZsY2VqYlBNNlo3RmhqcCtOZG5ZaTRpc1VyVStCWGFXM1VhV1lLSnZp?=
 =?utf-8?B?Z1VHQm9qTTU2aTl0M2FJT2xVQTE4d1JNaEVlUUxyS0xFZ0FQMUtaRnc5YmdR?=
 =?utf-8?B?dit4cEFNR0lGZk9ucHhIMUFLVks3ekFaM2FVd09BWjhPdldBMWdpdnhoMGtk?=
 =?utf-8?B?Smt3TFZ4OU1FTFhVL2ZOSDB2QjNQQ3cwMFZFVHdzQTBBOXN3OXNDQ1RDY0cw?=
 =?utf-8?B?RC9BdkVqeU9Gb3hqRVhzcHBGZFFHT3FGZDhTcStMcHJrQnVOV3VxMitWMHVm?=
 =?utf-8?B?R2Z4Ym83eFNMTkw1c1lPRExRY21VRG8yUnFmNEhQYU9YOXZUQnQvS3p2N1pq?=
 =?utf-8?B?UzFDR3ZGK3R1QWVwRnJBL2dmWktJekFUckhMc08rVXhmc251TU93a3lpWkQ4?=
 =?utf-8?B?S0Q4WC9Wd3VqWjd6ck5aQzhDQnoxbkszQ3dyYVY4eE13ajJCNERBdFFhemZw?=
 =?utf-8?B?Z2VTZFFYSStpbGdjeFlIOXBkSmJoekNuNjlRNG01T1FnbHJTZG54bi9ZaGVz?=
 =?utf-8?B?d1Bwekltd2tQK3FuSzV2YytIa1VmTEJHT1dnbGdGQkVmMmhlN0MwajYxL1lI?=
 =?utf-8?B?M05ueVMxcE9SWitDY1RGRnJoZXZNMW5jY3dVVnlkU0FOWXErVWkra3V2Q2Nr?=
 =?utf-8?B?RVB4M0FVNm9DRFJpc1ZjMEZ5d3BqNjRJNEQ0MlRDZEV6bzR0Z3h4MXVFT2xU?=
 =?utf-8?B?RVNyenZCNk1Td0FzbTkvbWo1eWV3MzhZak1qUHh3bnZjSzhhNnFwWmhrZ1lT?=
 =?utf-8?B?SVVZRnAwVS9yOFZBTGtxaTlDQm5wbkhrQStzcENSNXozV1BxcXZzWHBHZks2?=
 =?utf-8?B?NkU2TGdVTDNkTVhIcU5Idi96UElQSzlJbGo0WFdoUnZFSXdmdnRRcFVQc0c5?=
 =?utf-8?B?S0NkR2ZlVEVrUkxUODh0bjRkTkFRVEoyWC9XdlU1WElia2owVnNQSVkwbEhY?=
 =?utf-8?B?d3E5cGMwTnRqbFAzKzZjdWZEL3d0ZXdWVGg0TERFbktxNTV4cEJMakE4V1B1?=
 =?utf-8?Q?61hd12onbfDXta8I=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D3366BB7547F894780A29290484BE567@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB3032.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5d65ae9-3932-49f3-af62-08da55488c3f
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jun 2022 18:45:30.5024
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: d1kumPcuu6jdWKJND0JiuZTn9cGWXqA5uftx7ju/PnwAtsoLdkmd4dei3JnoaS8m
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB5046
X-Proofpoint-ORIG-GUID: duTHJZ92lyes_gwnTeoqBK1DwOK3Xxf-
X-Proofpoint-GUID: duTHJZ92lyes_gwnTeoqBK1DwOK3Xxf-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-23_08,2022-06-23_01,2022-06-22_01
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,MISSING_HEADERS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gT24gSnVuIDIzLCAyMDIyLCBhdCA4OjM5IEFNLCBDw6lkcmljIExlIEdvYXRlciA8Y2xn
QGthb2Qub3JnPiB3cm90ZToNCj4gDQo+IE9uIDYvMjMvMjIgMTQ6NTcsIFBldGVyIE1heWRlbGwg
d3JvdGU6DQo+PiBPbiBUaHUsIDIzIEp1biAyMDIyIGF0IDEzOjM3LCBQZXRlciBEZWxldm9yeWFz
IDxwZGVsQGZiLmNvbT4gd3JvdGU6DQo+Pj4gDQo+Pj4gTm90ZTogc3lzYnVzX21taW9fbWFwKCks
IHN5c2J1c19tbWlvX21hcF9vdmVybGFwKCksIGFuZCBvdGhlcnMgYXJlIHN0aWxsDQo+Pj4gdXNp
bmcgZ2V0X3N5c3RlbV9tZW1vcnkgaW5kaXJlY3RseS4NCj4+PiANCj4+PiBTaWduZWQtb2ZmLWJ5
OiBQZXRlciBEZWxldm9yeWFzIDxwZGVsQGZiLmNvbT4NCj4+PiAtLS0NCj4+PiAgaHcvYXJtL2Fz
cGVlZC5jICAgICAgICAgfCA4ICsrKystLS0tDQo+Pj4gIGh3L2FybS9hc3BlZWRfYXN0MTB4MC5j
IHwgNSArKy0tLQ0KPj4+ICBody9hcm0vYXNwZWVkX2FzdDI2MDAuYyB8IDIgKy0NCj4+PiAgaHcv
YXJtL2FzcGVlZF9zb2MuYyAgICAgfCA2ICsrKy0tLQ0KPj4+ICA0IGZpbGVzIGNoYW5nZWQsIDEw
IGluc2VydGlvbnMoKyksIDExIGRlbGV0aW9ucygtKQ0KPj4+IA0KPj4+IGRpZmYgLS1naXQgYS9o
dy9hcm0vYXNwZWVkLmMgYi9ody9hcm0vYXNwZWVkLmMNCj4+PiBpbmRleCA4ZGFlMTU1MTgzLi4z
YWE3NGU4OGZiIDEwMDY0NA0KPj4+IC0tLSBhL2h3L2FybS9hc3BlZWQuYw0KPj4+ICsrKyBiL2h3
L2FybS9hc3BlZWQuYw0KPj4+IEBAIC0zNzEsNyArMzcxLDcgQEAgc3RhdGljIHZvaWQgYXNwZWVk
X21hY2hpbmVfaW5pdChNYWNoaW5lU3RhdGUgKm1hY2hpbmUpDQo+Pj4gICAgICAgICAgICAgICAg
ICAgICAgICAgICBhbWMtPnVhcnRfZGVmYXVsdCk7DQo+Pj4gICAgICBxZGV2X3JlYWxpemUoREVW
SUNFKCZibWMtPnNvYyksIE5VTEwsICZlcnJvcl9hYm9ydCk7DQo+Pj4gDQo+Pj4gLSAgICBtZW1v
cnlfcmVnaW9uX2FkZF9zdWJyZWdpb24oZ2V0X3N5c3RlbV9tZW1vcnkoKSwNCj4+PiArICAgIG1l
bW9yeV9yZWdpb25fYWRkX3N1YnJlZ2lvbihibWMtPnNvYy5zeXN0ZW1fbWVtb3J5LA0KPj4+ICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHNjLT5tZW1tYXBbQVNQRUVEX0RFVl9TRFJB
TV0sDQo+Pj4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgJmJtYy0+cmFtX2NvbnRh
aW5lcik7DQo+PiBUaGlzIGlzIGJvYXJkIGNvZGUsIGl0IHNob3VsZG4ndCBiZSByZWFjaGluZyBp
bnRvIHRoZSBpbnRlcm5hbHMNCj4+IG9mIHRoZSBTb0Mgb2JqZWN0IGxpa2UgdGhpcy4gVGhlIGJv
YXJkIGNvZGUgcHJvYmFibHkgYWxyZWFkeQ0KPj4gaGFzIHRoZSByaWdodCBNZW1vcnlSZWdpb24g
YmVjYXVzZSBpdCB3YXMgdGhlIG9uZSB0aGF0IHBhc3NlZA0KPj4gaXQgdG8gdGhlIFNvQyBsaW5r
IHBvcnBlcnR5IGluIHRoZSBmaXJzdCBwbGFjZS4NCj4gDQo+IEl0J3MgYSBiaXQgbWVzc3kgY3Vy
cmVudGx5LiBNYXkgYmUgSSBnb3QgaXQgd3JvbmcgaW5pdGlhbGx5LiBUaGUNCj4gYm9hcmQgYWxs
b2NhdGVzIGEgcmFtIGNvbnRhaW5lciByZWdpb24gaW4gd2hpY2ggdGhlIG1hY2hpbmUgcmFtDQo+
IHJlZ2lvbiBpcyBtYXBwZWQuIFNlZSBjb21taXQgYWQxYTk3ODIxODZkICgiYXNwZWVkOiBhZGQg
YSBSQU0gbWVtb3J5DQo+IHJlZ2lvbiBjb250YWluZXIiKQ0KPiANCj4gVGhlcmUgaXMgYW4gZXh0
cmEgcmVnaW9uIGFmdGVyIHJhbSBpbiB0aGUgcmFtIGNvbnRhaW5lciB0byBjYXRjaA0KPiBpbnZh
bGlkIGFjY2VzcyBkb25lIGJ5IEZXLiBUaGF0J3MgaG93IEZXIGRldGVybWluZXMgdGhlIHNpemUg
b2YNCj4gcmFtLiBTZWUgY29tbWl0IGViZTMxYzBhOGVmNyAoImFzcGVlZDogYWRkIGEgbWF4X3Jh
bV9zaXplIHByb3BlcnR5DQo+IHRvIHRoZSBtZW1vcnkgY29udHJvbGxlciIpDQo+IA0KPiBCdXQg
SSB0aGluayBJIGNhbiBzYWZlbHkgbW92ZSBhbGwgdGhlIFJBTSBsb2dpYyB1bmRlciB0aGUgYm9h
cmQuDQo+IEkgd2lsbCBzZW5kIGEgcGF0Y2guDQoNCkFoIHllcywgSSBub3RpY2VkIHRoYXQgdGhp
cyB3YXMgb2RkIHRvbywgYW5kIHRoYXQgdGhlIERSQU0gcHJvYmFibHkNCnNob3VsZCBoYXZlIGJl
ZW4gbWFwcGVkIGluc2lkZSB0aGUgU29DIGNvZGUuIEkgZGlkbuKAmXQga25vdyBleGFjdGx5DQpo
b3cgdG8gc29sdmUgaXQgZWFzaWx5IHRob3VnaC4gVGhhbmtzIGZvciBzZW5kaW5nIGEgcGF0Y2gg
Q2VkcmljISENCg0KPiANCj4gVGhhbmtzLA0KPiANCj4gQy4NCj4gDQo+PiB0aGFua3MNCj4+IC0t
IFBNTQ0KPiANCg0K
