Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EEFF76DBE2
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 02:01:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232075AbjHCABZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Aug 2023 20:01:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbjHCABW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Aug 2023 20:01:22 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C44330D5
        for <kvm@vger.kernel.org>; Wed,  2 Aug 2023 17:01:22 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 372MiQd6002292;
        Thu, 3 Aug 2023 00:00:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=ZhVBVp2zN5foMi9prMVUnIdVfolxHhulH4pMB7HTZnE=;
 b=WCzwh3ogLemc1cg9S5+PWPneJTJh6ygEtudAQNN1uejjFywAB60LwWHdB6rvVV9phaL/
 ta/KDIDH54VJoPmoVWe7CGRMnjhdcsQRAfBnbtcWN7GhV9mGeKcYJqmJ2S9uW2mAcHRt
 YzJNFqzfX/uZOXNwXFgH0eGc7mebgovBytXkovfUYuFsvsKOodu/BaHf4/ontK0+imd/
 hEx5Q11tVRYrgp+VkliBq+11SyzxGoWkopIbiltho99CmKHOYnIACy06epdMCbPrEEoO
 Mf9l/BtRS6/gtO9Zclp08dIrOv0pwIqi24OkvIDIFxv44pavxe6j/7fljNI0rtfDM290 kA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s4sc2ghe0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Aug 2023 00:00:56 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 372N05it020596;
        Thu, 3 Aug 2023 00:00:55 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3s4s78uh61-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Aug 2023 00:00:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VHoyQE2JqiH+aREPAPCQdiZlex/V6mqa1c3VWrjCanesuFGuFioiX8W5MvlNk8q7rD93FffYx9JqAHj57EpomizsNaDK3/Avf0HA8lR86rWEUz+Usv+sIS+XW2n3xPBvgK6JuBDdznc9WQntzrKKjb+8AnQSqH+/yQJwszJBMvRTXqQv0n6EAFLsyO59aY7JCwgeUhyOnI/Bo6EyYKpzCh/VVLeDfIvW3mcjMxILBSjq4EGbg7VBW22o/28x21a6AE0czOddRPfLQWI2RgUBUiTnLJnFjnAkPA0rgPwkzSaQmNuegRiFzpuSIlbgLHUfFJjdFAvB2TRWHSC7kXtGkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZhVBVp2zN5foMi9prMVUnIdVfolxHhulH4pMB7HTZnE=;
 b=bQYqQ0VEa79ZnMxrQn4MpT1xCVTXfnKaGvP9I1jE9jPV3rNwK1ciIN/77xhAuK06MDoWfyb3/VhYWbsFsR0LjyXygLi3r8jxTpgSv/gmZI7FauBL4qBK60X8lpYZzEiG6ufFKzaLdlUMgTFszcQX5poIGvmdKxVsU8u4faGQHl9ajjvY/IM/TvdrNavvmv+1ewM37riLLji3I43UZObVnKVBYJkv0Z0xUcjbBfXqcWTRpkX1630/mrZ+UJTnvGpc/yf/UU3EMJko1HOEEf0TtF3DD4NV9OdvTZ6YVRNJyhFh42ipfV6HjoYZ7gBTJAb3JVI0KMyxiI7ZEgeetnS0pQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZhVBVp2zN5foMi9prMVUnIdVfolxHhulH4pMB7HTZnE=;
 b=RwTpEjHndXypXuQbBb6p00h/jVwU0O4HOaMhuFVKj0CSSW8v/G2uPyX8tPvPFngZBDnwyAe4zOsClOd9V7vbShUv/1jug7jO3z2aGybBAD64PGyd2qoAJWKC2GCf08qDWmTYG/syS+01fZcX5BQsPk6IxUKHmOglZCazwEt2F5Q=
Received: from PH0PR10MB5433.namprd10.prod.outlook.com (2603:10b6:510:e0::9)
 by CY8PR10MB7196.namprd10.prod.outlook.com (2603:10b6:930:72::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.37; Thu, 3 Aug
 2023 00:00:52 +0000
Received: from PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::76c:cb31:2005:d10c]) by PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::76c:cb31:2005:d10c%4]) with mapi id 15.20.6631.046; Thu, 3 Aug 2023
 00:00:52 +0000
From:   Miguel Luis <miguel.luis@oracle.com>
To:     Marc Zyngier <maz@kernel.org>
CC:     "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Mark Brown <broonie@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Chase Conklin <chase.conklin@arm.com>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Darren Hart <darren@os.amperecomputing.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v2 06/26] arm64: Add debug registers affected by
 HDFGxTR_EL2
Thread-Topic: [PATCH v2 06/26] arm64: Add debug registers affected by
 HDFGxTR_EL2
Thread-Index: AQHZwS3Mg+pTxrM9qE+WSxm3YegxbK/UGVsAgAM4nYCAAGbBgA==
Date:   Thu, 3 Aug 2023 00:00:52 +0000
Message-ID: <C4009786-DAF1-4BB7-8DF1-B249205B7F9A@oracle.com>
References: <20230728082952.959212-1-maz@kernel.org>
 <20230728082952.959212-7-maz@kernel.org>
 <61B845D3-A42B-451F-B74D-51B4A1FD28C6@oracle.com>
 <86leet5o20.wl-maz@kernel.org>
In-Reply-To: <86leet5o20.wl-maz@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR10MB5433:EE_|CY8PR10MB7196:EE_
x-ms-office365-filtering-correlation-id: 52c8b7fa-b3ce-442e-4d99-08db93b4b3ac
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wDNuj/tFngAlOSn3cs6uoTCK9RzgXz79CWPcFGn6P12S7uBVeArK79XJ9lqzRRtpolyWWU0ofDBjdOKwVxlrjhmSrYu0jQ+xL+6C7MujhSp9K0FGH1dPWZcEDZr07EwBBSyJxaQHVbjb14qXadfGWQTRxEhCyCTY/7KTegBdm0p7ECodUfo8eTfzuu3ltYZSHHKoH/CL2O+L6BiCi7ANYbpbV7SnoCMJs6FTqiLzcNB2rtafsue7N6PUPueK4uW+YuunYwGMMxqvk/LmWkF9t/mchzoDaMcMYl+O22AMirOWeMh7WMgzwNQ6GSZSTy/pTg44B53kLMEHS4Rk0rC9bMpMvdo+fu4VIWTk9rOpl4xoDpkNZdCvaXMUhC1Co3iEfI88uDCzh6VmmZ4fNDQi/r9YhHyBNa6arDj0KmtSDeZZZnVF05lq5fPfYot/CrkmWoEJVHvKZfwu/zM3Zp4dCiMoKvg5LiwZ5JrJ06fFk/xnqvedzqOD/IyuQVUGZkEWZPLFQIRW0AHO7m9BrDGRn7AJW3zkZ0F0teVXRZHH84OCozkuH5keiCRhFjRKot4VPO+c9bHpaGk7psZ0HuAEwnQLoW0SAf8maNwq58AO6RcnDx3ern4B1W1lk6xwbSVwbYG6hZVkjTyt3+wnK9nX0w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5433.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(39860400002)(366004)(396003)(136003)(346002)(451199021)(38100700002)(122000001)(86362001)(38070700005)(33656002)(6512007)(36756003)(478600001)(71200400001)(6486002)(2616005)(186003)(53546011)(8936002)(8676002)(6506007)(44832011)(5660300002)(7416002)(66476007)(66556008)(91956017)(66946007)(76116006)(54906003)(6916009)(4326008)(2906002)(41300700001)(66446008)(316002)(64756008)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?U0NBZElVYmV4TThhOEZFVmw5VFRhY253T0dFSks1LzVzdWVYSWIrdW5JQkxE?=
 =?utf-8?B?VDZ0NzA4dTZXUkZ1dElLajFqSEMxc2FSR3BucFNpcU4vNlRhUEdCZ0R5STlr?=
 =?utf-8?B?T2NlVU1jZWxod28rVHVWcjlzMFdhN1cwQnpnbFNlWVJPaWFuOXBUUSsxaThE?=
 =?utf-8?B?SWw1RCtLLzdJWS9OZm9ReDFhaWJma05PVzNidCtWaXoxaWVxZW4zanJvUmd1?=
 =?utf-8?B?M0RYY3F3NnlHZ2czVXFqSFpIQnB5TnRuQ2xPQ1ZsSEtXelBuei9MR0c5TW5K?=
 =?utf-8?B?MjNlZUw5M3B2MjU0WXJVdEQybjk2QjBSTjVvWmtNUXZTNUpGTFZDSmlQNDU5?=
 =?utf-8?B?eWJ6YWdua1o1TnR5OEIyQ3JzaVJacmR1TUMwaFdTNlNHZHpvM0I5eHlTcXpJ?=
 =?utf-8?B?NjhNZ3BNb2VrN1NFWmdDV3lKVXlVdGF3eUlrRGtEaE8xY1NMVmJ6TllnM1ds?=
 =?utf-8?B?N25leDlGeFcxeklzbmZmbHpoS0JPbE9HVEZ4cFI1R0VrWVRhN3FjaGkwbHB5?=
 =?utf-8?B?Q1dNRkg1OWtQUEZ6bXBQaDRYQ09nL2F4U1ovd0VhMGVKSXZaMkZHWVlRWS9i?=
 =?utf-8?B?VWtiM0oreUJoN2FCQ2R5emlTMnNNQnJIZHRYK3ZmWFhVNWpLNStTMHRrMHov?=
 =?utf-8?B?SjZrU0RyWkhVbE05ZmNOaDB6Yng1T2dQUS8zYWtyaGp2Y3FkNDVQZnJWOWJw?=
 =?utf-8?B?a3kvL2xBSndNaXAzaXRJMXNiTFRUVEdlWndVVm5Ed2VuQ1B5YWo4V1RWYWov?=
 =?utf-8?B?WUhIV0dScENlaHYyZ0E4NnNhZWJZTTV3S0JwV1JRblpwZXErMUE0cStKK0hw?=
 =?utf-8?B?S3ZUSS81eThwVEpKYmlhMnpXdk91Qnc1a0xXRTZGcUllZ21WWkh3TUZmY2lH?=
 =?utf-8?B?L01PRnBzNUlCKzRZZHdweXgwRFlBRm9pMXA5cFRzWHYvVkllVUpOYTVxOGF4?=
 =?utf-8?B?TW43VlUrRGVXR0NWUXAvbkR2UlBhR3pvNzIxckVmbkxyYWl0MkZnSU1pODZX?=
 =?utf-8?B?UytIRm11c0dMbUpCUVlWbXk2cmFJWENDZ01WaEpyVk5mOC8vZXhzRWNCQld2?=
 =?utf-8?B?bk0wZjNoOGtKREhEOFd1N0hXYlZ1RDRYZlAyYi9wdEM5bW1yaDMxM05aMVYz?=
 =?utf-8?B?Zno4ZGxUUS9mbklzRTBqYUM2a0lJUVlsSno5YnU0anpVZndPeWJIcTlVeGps?=
 =?utf-8?B?ZFRTRFlWQlF1L0pVZ0JlZVBjUEo1R1VLai96SWV5WXlNQmxaTlFLSXNzc0Vo?=
 =?utf-8?B?K3VOb2ZDUkdyQVo3cVBmYndOUEZqUEVDTGhjVzY1K1FxQnppQnRjbU1HQ2Qr?=
 =?utf-8?B?Vzc3UTJXWFF6MFVlNzNseVZJdGp4OXhQVkxpdlBleTJyQXFZQzJmdW9KeGRX?=
 =?utf-8?B?Vi85Vm4zOTNJY2VQVVAwREdtRWd3QS9HUUZYT0dzeC9sQjFyR0lJN1VLK1Fm?=
 =?utf-8?B?QlZBQmJGTU1BcVZycnZVZ0NpeERzS1F0L090akNqSk4yaEhmUWVzYzl2b3RU?=
 =?utf-8?B?VE5PMUovUld6T1h6cW8wTndzSXFMQnJIUEZraldvSWpRTldJdE9CN0MvQktu?=
 =?utf-8?B?aTBrNGRRWmNpRmhMOGtKa0IvcjlUeXJmNFFDbDBJMlVHbjRXVTk5NnJSVEtQ?=
 =?utf-8?B?YzNJeUI4T1JlY3U3MkZ1a0dSczFqRlVUeFMwVzJjUzJ1ZjF5VzJBSzArcS9R?=
 =?utf-8?B?ck9TTmtDWVB4MmlQMTJBcWlUY3BaWFBKcTdpbG05Q1pDYjFFTDdhcUg5VmZG?=
 =?utf-8?B?UE9Sb1lLMHg3OHRhK3pQV09weXNUQ1pab045OWkwakpMWjZBZ3RRcm9TUm9N?=
 =?utf-8?B?dFd1aUNxWFhCdVBYaUJFSWVmQk03OTFlVHlubWtkb0FOZVNhSFdpalhVdmFW?=
 =?utf-8?B?THQ3MzZJeXFZRHA2aTBxYXVBVFROcEt3aC9FV2RQZnJEejdjQUdJYTNSZDVO?=
 =?utf-8?B?Mnc1R3ljN3U5K0kyY09ESG9TVFhRU3ZrRmdFVWlCTHdLTFA1UkRMeDFDRG5x?=
 =?utf-8?B?aGxTQmpaSGRpWlFqU01sZ01nckJBT0dSNkRjMFgzYTd5MzhhTDNDZHg4dGJY?=
 =?utf-8?B?ZXlHNHpkQ2g3TDhUM0ZFaFRwRGEzYkkxNkpVajZWd2pnRk45RmU1SnJvc0gz?=
 =?utf-8?B?cFQzUjdyclR2VHFlQmpManRDWkM0RUx6QnJzYjY2VllGd0RYOEsxRkpBVFBZ?=
 =?utf-8?B?QkZPLzlhSVl1cnFaOTVDSlFJZ0Z4VTR6N3kra1crY2JRQlJHdlFrTGt1MmlK?=
 =?utf-8?B?b21hcEtzSkp0RlZLUUVZZjZUSDFRPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6EB8ED927FEF444F9F441BB5C8972DB5@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?L3dZQzNtMHRMeVlVbGJ2WXhCSWVkcCtDU1lZdUFrNXNMQ2ErL0U1bEpraXFC?=
 =?utf-8?B?RURDeUw1MGlOVWdadVJjdndzeTlrWENmdTBrdzcxVk9kM05lMUw0WkJNaCtj?=
 =?utf-8?B?R3dNSzc1ZkpiZEZrdjY2T2daZVdWS01sVzJjNTRtSTJ3K2tsMWNnOFB3VmlL?=
 =?utf-8?B?eDhtWjI5ZjBsWXB2RU9SL0ZkZUtDdzlKQkJ4VWhhMlRkU0NBZDAvb1djV1Br?=
 =?utf-8?B?NjBwcXBGN3lpell5Wng5UzA1SXdYUG9ybFk3MFlmQkxnRzZBNXhJem1JUXZY?=
 =?utf-8?B?V1JPSVRrQm0vY1hkaUtnUmpFblNKNHlBTlBYYlV1QXZTeGdhdzRlQU5ReXBk?=
 =?utf-8?B?WXc1MTZMRWN5Rmc2ajNpd3M0SDJZRU9mSXArbk44UWp2Q0FKVHdYQzVXOUlQ?=
 =?utf-8?B?WStSOE1iUERrdEpWSmtYNkZFbE5aQ2JOVGdJVEF5RFBYeDJXTWhzK2ZyMllF?=
 =?utf-8?B?dkg2b0ovY3RSNks3aGsrMHFIZ1JDRTRDdmNsTHgrNDJydzU1NGg2VnZVNkF3?=
 =?utf-8?B?WXowS3kvcFJzREJEL29wTWZrRFRPb3lYSCtkZWRaeG8rb1N6S3Bmb3lPczRr?=
 =?utf-8?B?OGRxNWtzZnp0UUVFWUNqN0I1SThmQ1JYbXNvbFBmN3VNbXI4MExXbWNnS095?=
 =?utf-8?B?bm5yclFOdktVMzYxK3ptYWZNV0lwR0lLSHpBUXVVcERZOUlPUU5peEg3dWEz?=
 =?utf-8?B?NWhIUThQVlNoZGExNmtDN0Q4a3h6OGRka0YzUG4yZlZnVDFKalpHbkR3NjIx?=
 =?utf-8?B?M2ZOR3pxTTczYkEyQXgwenZRRys0QklDbThUQUU1ZGNQNGZFU1gvL1NZN0w4?=
 =?utf-8?B?eTNpV3JJYnB6cU5rUWpBQUlOTkVFbUs1M1ZMdmpqQWNuVVFLSWRrbVlxdzlB?=
 =?utf-8?B?L3pNREJvanVRYjNtRjNzQmxpMCsxZTNvNlc5YkhZL05sTEhENk0zTnhvZ2sr?=
 =?utf-8?B?SjBzMHp1U09hUXArd01ya1NyWExZM2dtaFp3a3dnWTVYQldLZjczRUsyTjZa?=
 =?utf-8?B?NHJZR2ZUU1FLeTE1a2doVVhJNTIxL29PVGV3ZkNtNlh6M0I0NUxnaXNhNE5C?=
 =?utf-8?B?c1NJMHVJMHN4bnRTNWhTcWhHQlVEdWRhb0U0WFRWb2FRcnNJZS9mQXAwZkpp?=
 =?utf-8?B?QmJ1TU5lZjJwb1hiVzB5bzhXSG5mYXgveUNwbXhwck1EZEp3RkdhazdPcXJj?=
 =?utf-8?B?a3orbk5ucEZHWXBnUDdWeWJOUE1WWHZoV3BGOS84Q3BJZUI2Y1QwUlcvNU9G?=
 =?utf-8?B?UmdNMUFHMW96RnZDRzFSckdWd1cxUU1USHVBWWJyNUw4aWdQY0x6czB6cE1F?=
 =?utf-8?B?V3JwKzlpaWZiTXJUMFkxd2RzSXRFdGxYZll5Wm5xNGIvV2ptVU5ZelFPTUZX?=
 =?utf-8?Q?XIv+o3Es/YdC90owU6j2atLt+V2iD+d0=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5433.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52c8b7fa-b3ce-442e-4d99-08db93b4b3ac
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Aug 2023 00:00:52.0670
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Q4Pssdgm5EaK7uO7YToUyS/ekFDmX44M8CMO63xAGPnoRB6o8KNh8iAA7bFaudT227LQf6F5vJ5BxNmCvogBfw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB7196
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-08-02_19,2023-08-01_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 adultscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2308020212
X-Proofpoint-ORIG-GUID: Z_l7HV9trsfg6X9u_oCL_AAeAxmT7fO6
X-Proofpoint-GUID: Z_l7HV9trsfg6X9u_oCL_AAeAxmT7fO6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGkgTWFyYywNCg0KPiBPbiAyIEF1ZyAyMDIzLCBhdCAxNzo1MiwgTWFyYyBaeW5naWVyIDxtYXpA
a2VybmVsLm9yZz4gd3JvdGU6DQo+IA0KPiBPbiBNb24sIDMxIEp1bCAyMDIzIDE3OjQxOjQxICsw
MTAwLA0KPiBNaWd1ZWwgTHVpcyA8bWlndWVsLmx1aXNAb3JhY2xlLmNvbT4gd3JvdGU6DQo+PiAN
Cj4+IEhpIE1hcmMsDQo+PiANCj4+IEEgZmV3IGNvbW1lbnRzIG9uIHRoaXMgb25lLCBwbGVhc2Ug
c2VlIGJlbG93Lg0KPj4gDQo+Pj4gT24gMjggSnVsIDIwMjMsIGF0IDA4OjI5LCBNYXJjIFp5bmdp
ZXIgPG1hekBrZXJuZWwub3JnPiB3cm90ZToNCj4+PiANCj4+PiBUaGUgSERGR3hUUl9FTDIgcmVn
aXN0ZXJzIHRyYXAgYSAoaHVnZSkgc2V0IG9mIGRlYnVnIGFuZCB0cmFjZQ0KPj4+IHJlbGF0ZWQg
cmVnaXN0ZXJzLiBBZGQgdGhlaXIgZW5jb2RpbmdzIChhbmQgb25seSB0aGF0LCBiZWNhdXNlDQo+
Pj4gd2UgcmVhbGx5IGRvbid0IGNhcmUgYWJvdXQgd2hhdCB0aGVzZSByZWdpc3RlcnMgYWN0dWFs
bHkgZG8gYXQNCj4+PiB0aGlzIHN0YWdlKS4NCj4+PiANCj4+PiBTaWduZWQtb2ZmLWJ5OiBNYXJj
IFp5bmdpZXIgPG1hekBrZXJuZWwub3JnPg0KPj4+IC0tLQ0KPj4+IGFyY2gvYXJtNjQvaW5jbHVk
ZS9hc20vc3lzcmVnLmggfCA3OCArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysNCj4+
PiAxIGZpbGUgY2hhbmdlZCwgNzggaW5zZXJ0aW9ucygrKQ0KPj4+IA0KPj4+IGRpZmYgLS1naXQg
YS9hcmNoL2FybTY0L2luY2x1ZGUvYXNtL3N5c3JlZy5oIGIvYXJjaC9hcm02NC9pbmNsdWRlL2Fz
bS9zeXNyZWcuaA0KPj4+IGluZGV4IDc2Mjg5MzM5YjQzYi4uOWRmZDEyN2JlNTVhIDEwMDY0NA0K
Pj4+IC0tLSBhL2FyY2gvYXJtNjQvaW5jbHVkZS9hc20vc3lzcmVnLmgNCj4+PiArKysgYi9hcmNo
L2FybTY0L2luY2x1ZGUvYXNtL3N5c3JlZy5oDQo+Pj4gQEAgLTE5NCw2ICsxOTQsODQgQEANCj4+
PiAjZGVmaW5lIFNZU19EQkdEVFJUWF9FTDAgc3lzX3JlZygyLCAzLCAwLCA1LCAwKQ0KPj4+ICNk
ZWZpbmUgU1lTX0RCR1ZDUjMyX0VMMiBzeXNfcmVnKDIsIDQsIDAsIDcsIDApDQo+Pj4gDQo+Pj4g
KyNkZWZpbmUgU1lTX0JSQklORl9FTDEobikgc3lzX3JlZygyLCAxLCA4LCAobiAmIDE1KSwgKCgo
biAmIDE2KSA+PiAyKSB8IDApKQ0KPj4+ICsjZGVmaW5lIFNZU19CUkJJTkZJTkpfRUwxIHN5c19y
ZWcoMiwgMSwgOSwgMSwgMCkNCj4+PiArI2RlZmluZSBTWVNfQlJCU1JDX0VMMShuKSBzeXNfcmVn
KDIsIDEsIDgsIChuICYgMTUpLCAoKChuICYgMTYpID4+IDIpIHwgMSkpDQo+Pj4gKyNkZWZpbmUg
U1lTX0JSQlNSQ0lOSl9FTDEgc3lzX3JlZygyLCAxLCA5LCAxLCAxKQ0KPj4+ICsjZGVmaW5lIFNZ
U19CUkJUR1RfRUwxKG4pIHN5c19yZWcoMiwgMSwgOCwgKG4gJiAxNSksICgoKG4gJiAxNikgPj4g
MikgfCAyKSkNCj4+PiArI2RlZmluZSBTWVNfQlJCVEdUSU5KX0VMMSBzeXNfcmVnKDIsIDEsIDks
IDEsIDIpDQo+Pj4gKyNkZWZpbmUgU1lTX0JSQlRTX0VMMSBzeXNfcmVnKDIsIDEsIDksIDAsIDIp
DQo+Pj4gKw0KPj4+ICsjZGVmaW5lIFNZU19CUkJDUl9FTDEgc3lzX3JlZygyLCAxLCA5LCAwLCAw
KQ0KPj4+ICsjZGVmaW5lIFNZU19CUkJGQ1JfRUwxIHN5c19yZWcoMiwgMSwgOSwgMCwgMSkNCj4+
PiArI2RlZmluZSBTWVNfQlJCSURSMF9FTDEgc3lzX3JlZygyLCAxLCA5LCAyLCAwKQ0KPj4+ICsN
Cj4+PiArI2RlZmluZSBTWVNfVFJDSVRFQ1JfRUwxIHN5c19yZWcoMywgMCwgMSwgMiwgMykNCj4+
PiArI2RlZmluZSBTWVNfVFJDSVRFQ1JfRUwxIHN5c19yZWcoMywgMCwgMSwgMiwgMykNCj4+IA0K
Pj4gU1lTX1RSQ0lURUNSX0VMMSBzaG93cyB1cCB0d2ljZS4NCj4gDQo+IEFoLCBuaWNlIG9uZS4g
VG9vIG1hbnkgcmVnaXN0ZXJzLg0KPiANCj4+IA0KPj4+ICsjZGVmaW5lIFNZU19UUkNBQ0FUUiht
KSBzeXNfcmVnKDIsIDEsIDIsICgobSAmIDcpIDw8IDEpLCAoMiB8IChtID4+IDMpKSkNCj4+IA0K
Pj4gQmVzaWRlcyBt4oCZcyByZXN0cmljdGlvbnMgaXQgY291bGQgYmUgc2FuaXRpc2VkIGluIG9w
MiB0byBjb25zaWRlciBvbmx5IGJpdCBtWzNdLg0KPj4gU3VnZ2VzdGlvbiBmb3Igb3AyOiAoMiB8
ICgobSAmIDgpID4+IDMpKSkNCj4gDQo+IEl0IGlzIGZ1bGx5IGV4cGVjdGVkIHRoYXQgJ20nIHdp
bGwgYmUgaW4gdGhlIDAtMTUgcmFuZ2UsIGFzIHBlciB0aGUNCj4gYXJjaGl0ZWN0dXJlIChEMTku
NC44KSwgYW5kIHRoZSB0YWJsZXMgb25seSB1c2UgdGhhdCBleGFjdCByYW5nZS4NCj4gDQo+IERv
IHlvdSBzZWUgYW4gYWN0dWFsIGJ1Zywgb3IgaXMgdGhpcyBkZWZlbnNpdmUgcHJvZ3JhbW1pbmc/
DQo+IA0KDQpJIHdhcyBzZWVpbmcgYSBwcm9ibGVtIHdoZW4gbVs1XT0xIHRoZW4gT3AyIG9mIDBi
MDE6bVszXSBpc27igJl0IGd1YXJhbnRlZWQNCmFueW1vcmUgb3ZlcnJpZGRlbiB3aXRoIDBiMTE6
bVszXS4NCg0KQ2xlYXJseSDigJht4oCZIHdvdWxkIGJlIG91dHNpZGUgdGhlIHJhbmdlIGJ1dCBu
b3QgbWVzc2luZyB3aXRoIE9wMiBmaXhlZCBiaXRzIDBiMDEuDQpOb3QgYSBwcm9ibGVtIGZvciBw
YXRjaCAyMSB0aG91Z2guDQoNCkR1ZSB0byB0aGUgdW5jZXJ0YWludHkgaWYgdGhpcyBjYW4gYml0
ZSBsYXRlciwgaGVuY2UgdGhlIHN1Z2dlc3Rpb24gYW5kIGFsc28NCm9wZW4gdG8gYWR2aWNlcy4N
Cg0KVGhhbmsgeW91LA0KDQpNaWd1ZWwNCg0KDQo+IFRoYW5rcywNCj4gDQo+IE0uDQo+IA0KPiAt
LSANCj4gV2l0aG91dCBkZXZpYXRpb24gZnJvbSB0aGUgbm9ybSwgcHJvZ3Jlc3MgaXMgbm90IHBv
c3NpYmxlLg0KDQoNCg==
