Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E697783E9B
	for <lists+kvm@lfdr.de>; Tue, 22 Aug 2023 13:13:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234621AbjHVLNl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Aug 2023 07:13:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234603AbjHVLNi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Aug 2023 07:13:38 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25E2BCDB
        for <kvm@vger.kernel.org>; Tue, 22 Aug 2023 04:13:34 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37M1dLZJ028521;
        Tue, 22 Aug 2023 11:12:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=1O3Tp0n/M2F2MYK3Tf6sXr4Y5/HBRhwLtUt7JkkbcWo=;
 b=KDm/qV3gXKzBvZ60deHfE4ucxvImpvsTmKI1wtedjH11/sxlNzP8BjycDgZL2tqkbjcj
 Qr0mqM7+7chF7YgjC4JTvXojzGduQaIN+XwlmjJX+0g7QBHE+lsEaW4+UcNSecOFHISH
 LYD6g8Z3Nkmpo7j58TZKMBP2qMLnx1RcjSHDwkF+0n07/fDE3TGqHoPAYEZa+biL5B+s
 Ov+uEGfA4e35Ly7D3weWhm6wdIhI0obF2SYAvX0WQYYo01s7sEhANML5gh0sbyjLsn8B
 MPZqaJXbWFu2eErEVHbaWNXIeXXywn3OCur4etyfW+rsh/YBFGZj6W3Ob3ztKPALQWTY 7Q== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3sjp9ucxeq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Aug 2023 11:12:56 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 37M960XD029801;
        Tue, 22 Aug 2023 11:12:55 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2046.outbound.protection.outlook.com [104.47.66.46])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3sjm6b7kbv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Aug 2023 11:12:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hDLLqWzEuaYczTCeDvDt6nP+ckghcq6mnhNqgB3ox6i+DuevlagpfRXeQiGKR2T4zAXImsoU5QcsiEVu/WGHXMMRa9CjX7azTaodZEnq/9JwS98h1J9HcthtbsPOZxICcBJbbVV2qJReYwQBy9TI+sCkRvk7VhL9ofk33/JsqKxZc6uqiRuJ0WRW4WVEFUwH5Q8QfCLyQqalr0cE98B+F5Z2POjuDgMLx/zXsSzU5kFGXQSLr/Z7jBIW2pKHpUvH2nOON1DFLbsNLKKSA87VJn1tD4wKfpyc5vW5NkzOta0wWSROcYYAGbRZi6jA1W24vcQp0n0knF/Wnwp+mEhtPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1O3Tp0n/M2F2MYK3Tf6sXr4Y5/HBRhwLtUt7JkkbcWo=;
 b=PzCRUeQkqW9zM8iV/8izm4T0dw1gd+1Vvst8FMGnLc5619OmRYn8tpSq+KERLmjHj9KVAhM5wIlzvzL1lTAinMEYwG0bpt9wUyqaXPSDHBlNbZvHh+jB7oA0qIWaQksh5Xa7LT5NW0S2iCUn4cg/uFLDN+ctSfzzjEC9BvE/4Ft7u8c5qID/UZV+oZYSYrGV1km7ucoNVt2G3cQPp+HI1Fmyn5Ft/tUgKEMZt/WyzgStztq0nSesHQay0vPoJoZHuKsi/TMjZBglbLVbc8eXZKpaDMYDt3Y1U6krmZo3f+tnf2m3nC4oxCUL6zAnRLltyr75oE7SKiBK1Qo8araZmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1O3Tp0n/M2F2MYK3Tf6sXr4Y5/HBRhwLtUt7JkkbcWo=;
 b=iSMzZ6TzutXWYAhBRRiVoLS4Z8HV2gIp4ueDCPclucBwBKcwj7U+70yzn6hlBEpJLG8TWhNnnB9WJI1Ynfbr2MpBYYNPVigZkMBV1mRBMYsCw/fuRoWOyFhpW/yzY5J40QTUdhb354UNlW3Y6BzyR+PUcapRkRtFS9Zv8MGrp8Y=
Received: from PH0PR10MB5433.namprd10.prod.outlook.com (2603:10b6:510:e0::9)
 by IA0PR10MB7547.namprd10.prod.outlook.com (2603:10b6:208:493::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.24; Tue, 22 Aug
 2023 11:12:51 +0000
Received: from PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::76c:cb31:2005:d10c]) by PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::76c:cb31:2005:d10c%5]) with mapi id 15.20.6699.022; Tue, 22 Aug 2023
 11:12:51 +0000
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
        Jing Zhang <jingzhangos@google.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v4 15/28] KVM: arm64: nv: Add trap forwarding for HCR_EL2
Thread-Topic: [PATCH v4 15/28] KVM: arm64: nv: Add trap forwarding for HCR_EL2
Thread-Index: AQHZz6j8FVkRvNtG+kqTUjiTutrpaK/uVi0AgAa5mwCAASQFgA==
Date:   Tue, 22 Aug 2023 11:12:51 +0000
Message-ID: <67B7EB39-7DEF-4734-8211-53941AEE00ED@oracle.com>
References: <20230815183903.2735724-1-maz@kernel.org>
 <20230815183903.2735724-16-maz@kernel.org>
 <7B337015-DEB4-4E04-9A7A-AEDA0ECED71B@oracle.com>
 <86lee4fftb.wl-maz@kernel.org>
In-Reply-To: <86lee4fftb.wl-maz@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR10MB5433:EE_|IA0PR10MB7547:EE_
x-ms-office365-filtering-correlation-id: e87c4618-216e-4e0a-b07b-08dba300b9d0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cqLARPkP8YtXcY2q4CypP47Hyq0xWoRkiQVHVQeT0RngNglHr0csJseN9KvS3q60Z7YLIhBi1SN5hvar1zeuAZfcV2y8tcvTWXJmd7g2+1vnLiyRyGkgM47tiSIfkmGerbVYpV4i9xeJcFoiNXie3Vlwc9bE5oQwrQfDvTIHoU/vZ5cGAIO8rt2Wex27/Q+8xA9dDf2+kRfDGFhRO/NkPvxALmUyIGqJ5WxCVbsrDqooqmQM3RajJ4mjwEj0OAT4QX1OYTcv+Gva6nP/56KRg6Sk8JyxGIF7qMFuOwdmBE+iGiuaPvmwP3R51s8fDae5kfZH7vU9HT/WNjhNZ4ZoC1xwoH0/12fbc0/iWsBdRcNd4VK9mbPZRuH/HuE4h+H0/Oqi5DgYhjFRSm+s+KLb9vHc7gIGGQhNgJ8XKjj66yyQajNH/WCrrqZZZ+U/s4nHONHMNilJ9y9Jp0Ti/sEpxjTxgFIv0ZOdmsQhZjsQf3B/MCifT5109u7Ulql++1a80At3+5HZ5FN/Lg4X3VVsmjtNo43WmU/XsJzYjRMKYbS1Cz7nHgjBYlnX0ZJB/HrC6wPP1zjd/RydZOZOZ60ZtENw/A6MCwzZakDQeMcLjts+Pmd6zmrx+dXuA7+VFC4puOM2byLoMgUbPRqjqocvcg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5433.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(346002)(39860400002)(376002)(136003)(396003)(451199024)(186009)(1800799009)(83380400001)(2906002)(30864003)(7416002)(6486002)(53546011)(6506007)(38100700002)(5660300002)(44832011)(33656002)(86362001)(38070700005)(8676002)(4326008)(2616005)(8936002)(66946007)(316002)(64756008)(6512007)(54906003)(66556008)(6916009)(66446008)(76116006)(66476007)(91956017)(478600001)(122000001)(71200400001)(36756003)(41300700001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?lLlhG7D1Ms64Jg/nxXpIxrhUiTdaZePCOuLozDThVwi49IE2F9Cvb9D8IjId?=
 =?us-ascii?Q?qmHmYzQFz8iY0A3wnPVrBjkFJEFKTdwzap4rFGRpZxxzHVQ7vOyf5rn7v+S2?=
 =?us-ascii?Q?gvkjRn6kkKK+Pi7mruZJL7aGo5WU6p+LEzv85RTp332KKreWerC9qQndSs/+?=
 =?us-ascii?Q?tlvwLq4qhUuwwiSnsHwt8Nbcricwg4B2pk3xsph68O9F7aYpmdJUmkZ6qdo6?=
 =?us-ascii?Q?xi4aehM9FYnxLk+4G9/R71U7TnoHpOfpsHRlLDQZMsObeTTimKOLH1ARIrIR?=
 =?us-ascii?Q?TggxKcLNwaixplJJy007xu+v+a/Y22pcXFbcQEZIfzlWAeSofExYWwZd+Wbn?=
 =?us-ascii?Q?dgenKQFqFmVZpK/KdbqWkNrkJ73VudRN6bGSz6tk2rM1HjmyzbmHrdXqbEEJ?=
 =?us-ascii?Q?FdeJIf+slTl0UHGmIrdL5SoiWrmsUb/AYtx6/bEDL2/uShnxbIs+4MOXVJO6?=
 =?us-ascii?Q?hkdAQiie/p0kvsXL11rpUOoqDM8nawI6uJJOcZfJdSz/nKUf6/eCSor6ohK7?=
 =?us-ascii?Q?5tNTerf2iJTL80s12uhVcxutTt1dAIUKY5CSYD9OqKLa/LNNxGdc64RwNqEc?=
 =?us-ascii?Q?4REbSfA4otYfBWe88uTLa+lPzVuW6bT4Y5PNVgFEsrz2JYHIKIp/6mU+z9Wd?=
 =?us-ascii?Q?3j2ylQvJLqqRb7x9MSQjmBXf+Y4hpw0E+yRR61OkcuQ6xGDm++2+nt6L4aPO?=
 =?us-ascii?Q?9v9imBWmWNQ2n4prcYmrswEak45XvLLO28GSHwhML4mtNF595mOaSVLZUDmZ?=
 =?us-ascii?Q?PBNVIwkMzG427oV3TPyc1QNkDpEW2L5kVcnGVExC2CDcXEqL4mFNhV8qWCsX?=
 =?us-ascii?Q?IEY3NXo2BKJsKNG9Jsv1CGQXGNskZut3gD7g4PLpdgJBLkp+CzEMz2RPeDwS?=
 =?us-ascii?Q?PpRTNjkgxgxTKCrFySyVI9ImwZjSKfjMRpUJNf3R37gvSl2Twe6uxwkjFtdq?=
 =?us-ascii?Q?WFED04nJMAFG6zAES8UM54KHlb/BX+SIpn3tM+iuFsIf6ZHi2REgy6j5m96c?=
 =?us-ascii?Q?Xv1nVj4KWudZGrZPEio3rsKz+QkWjPpAxGkR0S3wmYUIV3zQIvPUU1pibj9g?=
 =?us-ascii?Q?p1vrHrKh9zWRbo4zj+JM/FqhBjInCmMyUNiyfKVamOYoehJFy7+o3lRhEvEG?=
 =?us-ascii?Q?Jm8wC7uqzyIBiJY4OTneuiI0YbmHTWXjhNIFKLCa5LjatAQDbXrL2rDxG48o?=
 =?us-ascii?Q?wPJTd3svgeqSBpuU4F1/FMHAk5YOjW3SXNdBC5eyBSlxZBqVo31fK5RiL6So?=
 =?us-ascii?Q?Utub71IlycL6ELeswuM+H35/wc/szdHyK3HfVa4igSf+/N2krH5R1rvIUWkP?=
 =?us-ascii?Q?E2pf1Tc6sDIjNUCxk2TMyTRtC/At6y2BsZgR4ETafl6zE/b4uemfQ6xjrVdq?=
 =?us-ascii?Q?x3jxEDvFPdVJyC8ElIjybI/qLNHb2x31V+ZjYeb9zQY/uZQGGnmitNs8N8rt?=
 =?us-ascii?Q?O9z1t5F7MiSrBtsuE9d+YpSBqYDBQpuxVh6avHcJgxnWqiljS6EX4f/rQXWh?=
 =?us-ascii?Q?YIjmRKuzKTh4DDBq6sslg3ew0DfqKP3obPeSm5QONXc0DU2gk0/SKGLmhDKN?=
 =?us-ascii?Q?5Bh/0GiM0wgut+OnstPItRWvLFJMPsENlVL41gWP/t3Z34Y8dc5oCKoojqTW?=
 =?us-ascii?Q?xw++/OtjVc6bRA1Na3u/758=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1FDB2B432A45FB43825D9E6EE3E39BB0@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?oisTUwEkTjy7Uu9WCYQSTud/PyepBwHt5BFBi9oypaZhACov/JIp0SJsGN3A?=
 =?us-ascii?Q?fZDeHqaByx0Oh23fLzotMPGTKyUJ6ZKz8f4uy/fanH6hSOkyxEdWgQUR/w2P?=
 =?us-ascii?Q?uqefjjGQ41O+NQ6GnNEguBu8gaZSc9Rc/nCqz7UenT1/3K1BEX/GO2YJ7bxj?=
 =?us-ascii?Q?aewi2c9WRVKReLnQWQX/1Ovia3eR+aed2l18YzsNiYHi8G/O7Acn005fKbCi?=
 =?us-ascii?Q?elVyrOvxe3OuluVEor16gWfWMLtXz0LdQBqxCxEux/X0fX4y35R8ZY7bgvNy?=
 =?us-ascii?Q?agyPdU+Bw7GiO8G7+hJHD4+oKTz3TmiLP9gLHcYT92d26IhL/YWsIMkJPcCe?=
 =?us-ascii?Q?6gzWm83bdaB5WtHiYjmWoN6dFhBNEnOssBqB7JYKbGws5KoiSxoFnG5dVUER?=
 =?us-ascii?Q?kZnqkEV8px/v4k5+CDLb3L0jUXJvkIYiyIW+F6ynxfTDcc/I7lDjdsU8zhpG?=
 =?us-ascii?Q?d86JkByg4mUsQmZQiM6a+4P+sn7aP8epVTRYF4CLG8ck+leVmAwk7Ejl63NK?=
 =?us-ascii?Q?sOGl5VNjYnPEvODZJBjCG4cPv74IOy/J706E31bYtHi9jPOYI1x/p1YaYCc6?=
 =?us-ascii?Q?l21G1M90cCKi9fqIQATzcDj7KDOz/ko4qWQIaSnaiQNzsqHRWnBNiDXUmmGu?=
 =?us-ascii?Q?fbHfXCmCswOlVAAZIRRQMfPO1eYG37kiveeabjxejAMTtFM5+W7mF2xoDZdU?=
 =?us-ascii?Q?6ohiGXhiwxPMKm/86QTldA/Bm5KtrUTFoe/KXQwE94YcUxzk+O9JzvhYBKEu?=
 =?us-ascii?Q?A9s5k/hi0vCvRbusKsIb3FLP2CyfFSl2TJ+r35HV7p4W+MeXsMAc6j/D+dt4?=
 =?us-ascii?Q?GDUwW3Fij1Z3e1AtDUQM5Tvppr6OkRMNM0tWDAWA3L7lBjJDvyP6HXoCt/3C?=
 =?us-ascii?Q?x8hGErvVwb6/wBMtOfOvPOySyUooELDPvGzzbF6Km6XFhLc0eByvkeTiMs8r?=
 =?us-ascii?Q?Vm7Mw2ejQ9yD2WZwBfgPROwEHxyxkAeuEWmrvNCOzyouLxNlJk8ngIFZ4eOD?=
 =?us-ascii?Q?plypnKwssxhaXkYRYFtk6VqemOvhj7lgDe9waQX6VQg6Bd89xV0fI1ZajEvr?=
 =?us-ascii?Q?AH0vgMRDv3K+dO9RJSBr84WFUGqDRw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5433.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e87c4618-216e-4e0a-b07b-08dba300b9d0
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Aug 2023 11:12:51.5596
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /rTEEr4T/y4WbCOcrIC9cNSWPR/UmM6pF6RNr6MFEgej7ixDGp128d7HtQ/jO4CoWkJyhoXenz4GrMqKTvGhGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7547
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-22_10,2023-08-22_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 suspectscore=0
 bulkscore=0 malwarescore=0 mlxscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2308220084
X-Proofpoint-ORIG-GUID: Jf42bFjxsdnLSwk9zfNOWzb4Tjpv8ks4
X-Proofpoint-GUID: Jf42bFjxsdnLSwk9zfNOWzb4Tjpv8ks4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        UPPERCASE_50_75 autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

> On 21 Aug 2023, at 17:47, Marc Zyngier <maz@kernel.org> wrote:
>=20
> On Thu, 17 Aug 2023 12:05:49 +0100,
> Miguel Luis <miguel.luis@oracle.com> wrote:
>>=20
>> Hi Marc,
>>=20
>>> On 15 Aug 2023, at 18:38, Marc Zyngier <maz@kernel.org> wrote:
>>>=20
>>> Describe the HCR_EL2 register, and associate it with all the sysregs
>>> it allows to trap.
>>>=20
>>> Reviewed-by: Eric Auger <eric.auger@redhat.com>
>>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>>> ---
>>> arch/arm64/kvm/emulate-nested.c | 488 ++++++++++++++++++++++++++++++++
>>> 1 file changed, 488 insertions(+)
>>>=20
>>> diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-n=
ested.c
>>> index d5837ed0077c..975a30ef874a 100644
>>> --- a/arch/arm64/kvm/emulate-nested.c
>>> +++ b/arch/arm64/kvm/emulate-nested.c
>>> @@ -38,12 +38,48 @@ enum cgt_group_id {
>>> * on their own instead of being part of a combination of
>>> * trap controls.
>>> */
>>> + CGT_HCR_TID1,
>>> + CGT_HCR_TID2,
>>> + CGT_HCR_TID3,
>>> + CGT_HCR_IMO,
>>> + CGT_HCR_FMO,
>>> + CGT_HCR_TIDCP,
>>> + CGT_HCR_TACR,
>>> + CGT_HCR_TSW,
>>> + CGT_HCR_TPC,
>>> + CGT_HCR_TPU,
>>> + CGT_HCR_TTLB,
>>> + CGT_HCR_TVM,
>>> + CGT_HCR_TDZ,
>>> + CGT_HCR_TRVM,
>>> + CGT_HCR_TLOR,
>>> + CGT_HCR_TERR,
>>> + CGT_HCR_APK,
>>> + CGT_HCR_NV,
>>> + CGT_HCR_NV_nNV2,
>>> + CGT_HCR_NV1_nNV2,
>>> + CGT_HCR_AT,
>>> + CGT_HCR_nFIEN,
>>> + CGT_HCR_TID4,
>>> + CGT_HCR_TICAB,
>>> + CGT_HCR_TOCU,
>>> + CGT_HCR_ENSCXT,
>>> + CGT_HCR_TTLBIS,
>>> + CGT_HCR_TTLBOS,
>>>=20
>>> /*
>>> * Anything after this point is a combination of coarse trap
>>> * controls, which must all be evaluated to decide what to do.
>>> */
>>> __MULTIPLE_CONTROL_BITS__,
>>> + CGT_HCR_IMO_FMO =3D __MULTIPLE_CONTROL_BITS__,
>>> + CGT_HCR_TID2_TID4,
>>> + CGT_HCR_TTLB_TTLBIS,
>>> + CGT_HCR_TTLB_TTLBOS,
>>> + CGT_HCR_TVM_TRVM,
>>> + CGT_HCR_TPU_TICAB,
>>> + CGT_HCR_TPU_TOCU,
>>> + CGT_HCR_NV1_nNV2_ENSCXT,
>>>=20
>>> /*
>>> * Anything after this point requires a callback evaluating a
>>> @@ -56,6 +92,174 @@ enum cgt_group_id {
>>> };
>>>=20
>>> static const struct trap_bits coarse_trap_bits[] =3D {
>>> + [CGT_HCR_TID1] =3D {
>>> + .index =3D HCR_EL2,
>>> + .value =3D HCR_TID1,
>>> + .mask =3D HCR_TID1,
>>> + .behaviour =3D BEHAVE_FORWARD_READ,
>>> + },
>>> + [CGT_HCR_TID2] =3D {
>>> + .index =3D HCR_EL2,
>>> + .value =3D HCR_TID2,
>>> + .mask =3D HCR_TID2,
>>> + .behaviour =3D BEHAVE_FORWARD_ANY,
>>> + },
>>> + [CGT_HCR_TID3] =3D {
>>> + .index =3D HCR_EL2,
>>> + .value =3D HCR_TID3,
>>> + .mask =3D HCR_TID3,
>>> + .behaviour =3D BEHAVE_FORWARD_READ,
>>> + },
>>> + [CGT_HCR_IMO] =3D {
>>> + .index =3D HCR_EL2,
>>> + .value =3D HCR_IMO,
>>> + .mask =3D HCR_IMO,
>>> + .behaviour =3D BEHAVE_FORWARD_WRITE,
>>> + },
>>> + [CGT_HCR_FMO] =3D {
>>> + .index =3D HCR_EL2,
>>> + .value =3D HCR_FMO,
>>> + .mask =3D HCR_FMO,
>>> + .behaviour =3D BEHAVE_FORWARD_WRITE,
>>> + },
>>> + [CGT_HCR_TIDCP] =3D {
>>> + .index =3D HCR_EL2,
>>> + .value =3D HCR_TIDCP,
>>> + .mask =3D HCR_TIDCP,
>>> + .behaviour =3D BEHAVE_FORWARD_ANY,
>>> + },
>>> + [CGT_HCR_TACR] =3D {
>>> + .index =3D HCR_EL2,
>>> + .value =3D HCR_TACR,
>>> + .mask =3D HCR_TACR,
>>> + .behaviour =3D BEHAVE_FORWARD_ANY,
>>> + },
>>> + [CGT_HCR_TSW] =3D {
>>> + .index =3D HCR_EL2,
>>> + .value =3D HCR_TSW,
>>> + .mask =3D HCR_TSW,
>>> + .behaviour =3D BEHAVE_FORWARD_ANY,
>>> + },
>>> + [CGT_HCR_TPC] =3D { /* Also called TCPC when FEAT_DPB is implemented =
*/
>>> + .index =3D HCR_EL2,
>>> + .value =3D HCR_TPC,
>>> + .mask =3D HCR_TPC,
>>> + .behaviour =3D BEHAVE_FORWARD_ANY,
>>> + },
>>> + [CGT_HCR_TPU] =3D {
>>> + .index =3D HCR_EL2,
>>> + .value =3D HCR_TPU,
>>> + .mask =3D HCR_TPU,
>>> + .behaviour =3D BEHAVE_FORWARD_ANY,
>>> + },
>>> + [CGT_HCR_TTLB] =3D {
>>> + .index =3D HCR_EL2,
>>> + .value =3D HCR_TTLB,
>>> + .mask =3D HCR_TTLB,
>>> + .behaviour =3D BEHAVE_FORWARD_ANY,
>>> + },
>>> + [CGT_HCR_TVM] =3D {
>>> + .index =3D HCR_EL2,
>>> + .value =3D HCR_TVM,
>>> + .mask =3D HCR_TVM,
>>> + .behaviour =3D BEHAVE_FORWARD_WRITE,
>>> + },
>>> + [CGT_HCR_TDZ] =3D {
>>> + .index =3D HCR_EL2,
>>> + .value =3D HCR_TDZ,
>>> + .mask =3D HCR_TDZ,
>>> + .behaviour =3D BEHAVE_FORWARD_ANY,
>>> + },
>>> + [CGT_HCR_TRVM] =3D {
>>> + .index =3D HCR_EL2,
>>> + .value =3D HCR_TRVM,
>>> + .mask =3D HCR_TRVM,
>>> + .behaviour =3D BEHAVE_FORWARD_READ,
>>> + },
>>> + [CGT_HCR_TLOR] =3D {
>>> + .index =3D HCR_EL2,
>>> + .value =3D HCR_TLOR,
>>> + .mask =3D HCR_TLOR,
>>> + .behaviour =3D BEHAVE_FORWARD_ANY,
>>> + },
>>> + [CGT_HCR_TERR] =3D {
>>> + .index =3D HCR_EL2,
>>> + .value =3D HCR_TERR,
>>> + .mask =3D HCR_TERR,
>>> + .behaviour =3D BEHAVE_FORWARD_ANY,
>>> + },
>>> + [CGT_HCR_APK] =3D {
>>> + .index =3D HCR_EL2,
>>> + .value =3D 0,
>>> + .mask =3D HCR_APK,
>>> + .behaviour =3D BEHAVE_FORWARD_ANY,
>>> + },
>>> + [CGT_HCR_NV] =3D {
>>> + .index =3D HCR_EL2,
>>> + .value =3D HCR_NV,
>>> + .mask =3D HCR_NV,
>>> + .behaviour =3D BEHAVE_FORWARD_ANY,
>>> + },
>>> + [CGT_HCR_NV_nNV2] =3D {
>>> + .index =3D HCR_EL2,
>>> + .value =3D HCR_NV,
>>> + .mask =3D HCR_NV | HCR_NV2,
>>> + .behaviour =3D BEHAVE_FORWARD_ANY,
>>> + },
>>> + [CGT_HCR_NV1_nNV2] =3D {
>>> + .index =3D HCR_EL2,
>>> + .value =3D HCR_NV | HCR_NV1,
>>> + .mask =3D HCR_NV | HCR_NV1 | HCR_NV2,
>>> + .behaviour =3D BEHAVE_FORWARD_ANY,
>>> + },
>>> + [CGT_HCR_AT] =3D {
>>> + .index =3D HCR_EL2,
>>> + .value =3D HCR_AT,
>>> + .mask =3D HCR_AT,
>>> + .behaviour =3D BEHAVE_FORWARD_ANY,
>>> + },
>>> + [CGT_HCR_nFIEN] =3D {
>>> + .index =3D HCR_EL2,
>>> + .value =3D 0,
>>> + .mask =3D HCR_FIEN,
>>> + .behaviour =3D BEHAVE_FORWARD_ANY,
>>> + },
>>> + [CGT_HCR_TID4] =3D {
>>> + .index =3D HCR_EL2,
>>> + .value =3D HCR_TID4,
>>> + .mask =3D HCR_TID4,
>>> + .behaviour =3D BEHAVE_FORWARD_ANY,
>>> + },
>>> + [CGT_HCR_TICAB] =3D {
>>> + .index =3D HCR_EL2,
>>> + .value =3D HCR_TICAB,
>>> + .mask =3D HCR_TICAB,
>>> + .behaviour =3D BEHAVE_FORWARD_ANY,
>>> + },
>>> + [CGT_HCR_TOCU] =3D {
>>> + .index =3D HCR_EL2,
>>> + .value =3D HCR_TOCU,
>>> + .mask =3D HCR_TOCU,
>>> + .behaviour =3D BEHAVE_FORWARD_ANY,
>>> + },
>>> + [CGT_HCR_ENSCXT] =3D {
>>> + .index =3D HCR_EL2,
>>> + .value =3D 0,
>>> + .mask =3D HCR_ENSCXT,
>>> + .behaviour =3D BEHAVE_FORWARD_ANY,
>>> + },
>>> + [CGT_HCR_TTLBIS] =3D {
>>> + .index =3D HCR_EL2,
>>> + .value =3D HCR_TTLBIS,
>>> + .mask =3D HCR_TTLBIS,
>>> + .behaviour =3D BEHAVE_FORWARD_ANY,
>>> + },
>>> + [CGT_HCR_TTLBOS] =3D {
>>> + .index =3D HCR_EL2,
>>> + .value =3D HCR_TTLBOS,
>>> + .mask =3D HCR_TTLBOS,
>>> + .behaviour =3D BEHAVE_FORWARD_ANY,
>>> + },
>>> };
>>>=20
>>> #define MCB(id, ...) \
>>> @@ -65,6 +269,14 @@ static const struct trap_bits coarse_trap_bits[] =
=3D {
>>> }
>>>=20
>>> static const enum cgt_group_id *coarse_control_combo[] =3D {
>>> + MCB(CGT_HCR_IMO_FMO, CGT_HCR_IMO, CGT_HCR_FMO),
>>> + MCB(CGT_HCR_TID2_TID4, CGT_HCR_TID2, CGT_HCR_TID4),
>>> + MCB(CGT_HCR_TTLB_TTLBIS, CGT_HCR_TTLB, CGT_HCR_TTLBIS),
>>> + MCB(CGT_HCR_TTLB_TTLBOS, CGT_HCR_TTLB, CGT_HCR_TTLBOS),
>>> + MCB(CGT_HCR_TVM_TRVM, CGT_HCR_TVM, CGT_HCR_TRVM),
>>> + MCB(CGT_HCR_TPU_TICAB, CGT_HCR_TPU, CGT_HCR_TICAB),
>>> + MCB(CGT_HCR_TPU_TOCU, CGT_HCR_TPU, CGT_HCR_TOCU),
>>> + MCB(CGT_HCR_NV1_nNV2_ENSCXT, CGT_HCR_NV1_nNV2, CGT_HCR_ENSCXT),
>>> };
>>>=20
>>> typedef enum trap_behaviour (*complex_condition_check)(struct kvm_vcpu =
*);
>>> @@ -121,6 +333,282 @@ struct encoding_to_trap_config {
>>> * re-injected in the nested hypervisor.
>>> */
>>> static const struct encoding_to_trap_config encoding_to_cgt[] __initcon=
st =3D {
>>> + SR_TRAP(SYS_REVIDR_EL1, CGT_HCR_TID1),
>>> + SR_TRAP(SYS_AIDR_EL1, CGT_HCR_TID1),
>>> + SR_TRAP(SYS_SMIDR_EL1, CGT_HCR_TID1),
>>> + SR_TRAP(SYS_CTR_EL0, CGT_HCR_TID2),
>>> + SR_TRAP(SYS_CCSIDR_EL1, CGT_HCR_TID2_TID4),
>>> + SR_TRAP(SYS_CCSIDR2_EL1, CGT_HCR_TID2_TID4),
>>> + SR_TRAP(SYS_CLIDR_EL1, CGT_HCR_TID2_TID4),
>>> + SR_TRAP(SYS_CSSELR_EL1, CGT_HCR_TID2_TID4),
>>> + SR_RANGE_TRAP(SYS_ID_PFR0_EL1,
>>> +      sys_reg(3, 0, 0, 7, 7), CGT_HCR_TID3),
>>> + SR_TRAP(SYS_ICC_SGI0R_EL1, CGT_HCR_IMO_FMO),
>>> + SR_TRAP(SYS_ICC_ASGI1R_EL1, CGT_HCR_IMO_FMO),
>>> + SR_TRAP(SYS_ICC_SGI1R_EL1, CGT_HCR_IMO_FMO),
>>> + SR_RANGE_TRAP(sys_reg(3, 0, 11, 0, 0),
>>> +      sys_reg(3, 0, 11, 15, 7), CGT_HCR_TIDCP),
>>> + SR_RANGE_TRAP(sys_reg(3, 1, 11, 0, 0),
>>> +      sys_reg(3, 1, 11, 15, 7), CGT_HCR_TIDCP),
>>> + SR_RANGE_TRAP(sys_reg(3, 2, 11, 0, 0),
>>> +      sys_reg(3, 2, 11, 15, 7), CGT_HCR_TIDCP),
>>> + SR_RANGE_TRAP(sys_reg(3, 3, 11, 0, 0),
>>> +      sys_reg(3, 3, 11, 15, 7), CGT_HCR_TIDCP),
>>> + SR_RANGE_TRAP(sys_reg(3, 4, 11, 0, 0),
>>> +      sys_reg(3, 4, 11, 15, 7), CGT_HCR_TIDCP),
>>> + SR_RANGE_TRAP(sys_reg(3, 5, 11, 0, 0),
>>> +      sys_reg(3, 5, 11, 15, 7), CGT_HCR_TIDCP),
>>> + SR_RANGE_TRAP(sys_reg(3, 6, 11, 0, 0),
>>> +      sys_reg(3, 6, 11, 15, 7), CGT_HCR_TIDCP),
>>> + SR_RANGE_TRAP(sys_reg(3, 7, 11, 0, 0),
>>> +      sys_reg(3, 7, 11, 15, 7), CGT_HCR_TIDCP),
>>> + SR_RANGE_TRAP(sys_reg(3, 0, 15, 0, 0),
>>> +      sys_reg(3, 0, 15, 15, 7), CGT_HCR_TIDCP),
>>> + SR_RANGE_TRAP(sys_reg(3, 1, 15, 0, 0),
>>> +      sys_reg(3, 1, 15, 15, 7), CGT_HCR_TIDCP),
>>> + SR_RANGE_TRAP(sys_reg(3, 2, 15, 0, 0),
>>> +      sys_reg(3, 2, 15, 15, 7), CGT_HCR_TIDCP),
>>> + SR_RANGE_TRAP(sys_reg(3, 3, 15, 0, 0),
>>> +      sys_reg(3, 3, 15, 15, 7), CGT_HCR_TIDCP),
>>> + SR_RANGE_TRAP(sys_reg(3, 4, 15, 0, 0),
>>> +      sys_reg(3, 4, 15, 15, 7), CGT_HCR_TIDCP),
>>> + SR_RANGE_TRAP(sys_reg(3, 5, 15, 0, 0),
>>> +      sys_reg(3, 5, 15, 15, 7), CGT_HCR_TIDCP),
>>> + SR_RANGE_TRAP(sys_reg(3, 6, 15, 0, 0),
>>> +      sys_reg(3, 6, 15, 15, 7), CGT_HCR_TIDCP),
>>> + SR_RANGE_TRAP(sys_reg(3, 7, 15, 0, 0),
>>> +      sys_reg(3, 7, 15, 15, 7), CGT_HCR_TIDCP),
>>> + SR_TRAP(SYS_ACTLR_EL1, CGT_HCR_TACR),
>>> + SR_TRAP(SYS_DC_ISW, CGT_HCR_TSW),
>>> + SR_TRAP(SYS_DC_CSW, CGT_HCR_TSW),
>>> + SR_TRAP(SYS_DC_CISW, CGT_HCR_TSW),
>>> + SR_TRAP(SYS_DC_IGSW, CGT_HCR_TSW),
>>> + SR_TRAP(SYS_DC_IGDSW, CGT_HCR_TSW),
>>> + SR_TRAP(SYS_DC_CGSW, CGT_HCR_TSW),
>>> + SR_TRAP(SYS_DC_CGDSW, CGT_HCR_TSW),
>>> + SR_TRAP(SYS_DC_CIGSW, CGT_HCR_TSW),
>>> + SR_TRAP(SYS_DC_CIGDSW, CGT_HCR_TSW),
>>> + SR_TRAP(SYS_DC_CIVAC, CGT_HCR_TPC),
>>> + SR_TRAP(SYS_DC_CVAC, CGT_HCR_TPC),
>>> + SR_TRAP(SYS_DC_CVAP, CGT_HCR_TPC),
>>> + SR_TRAP(SYS_DC_CVADP, CGT_HCR_TPC),
>>> + SR_TRAP(SYS_DC_IVAC, CGT_HCR_TPC),
>>> + SR_TRAP(SYS_DC_CIGVAC, CGT_HCR_TPC),
>>> + SR_TRAP(SYS_DC_CIGDVAC, CGT_HCR_TPC),
>>> + SR_TRAP(SYS_DC_IGVAC, CGT_HCR_TPC),
>>> + SR_TRAP(SYS_DC_IGDVAC, CGT_HCR_TPC),
>>> + SR_TRAP(SYS_DC_CGVAC, CGT_HCR_TPC),
>>> + SR_TRAP(SYS_DC_CGDVAC, CGT_HCR_TPC),
>>> + SR_TRAP(SYS_DC_CGVAP, CGT_HCR_TPC),
>>> + SR_TRAP(SYS_DC_CGDVAP, CGT_HCR_TPC),
>>> + SR_TRAP(SYS_DC_CGVADP, CGT_HCR_TPC),
>>> + SR_TRAP(SYS_DC_CGDVADP, CGT_HCR_TPC),
>>> + SR_TRAP(SYS_IC_IVAU, CGT_HCR_TPU_TOCU),
>>> + SR_TRAP(SYS_IC_IALLU, CGT_HCR_TPU_TOCU),
>>> + SR_TRAP(SYS_IC_IALLUIS, CGT_HCR_TPU_TICAB),
>>> + SR_TRAP(SYS_DC_CVAU, CGT_HCR_TPU_TOCU),
>>> + SR_TRAP(OP_TLBI_RVAE1, CGT_HCR_TTLB),
>>> + SR_TRAP(OP_TLBI_RVAAE1, CGT_HCR_TTLB),
>>> + SR_TRAP(OP_TLBI_RVALE1, CGT_HCR_TTLB),
>>> + SR_TRAP(OP_TLBI_RVAALE1, CGT_HCR_TTLB),
>>> + SR_TRAP(OP_TLBI_VMALLE1, CGT_HCR_TTLB),
>>> + SR_TRAP(OP_TLBI_VAE1, CGT_HCR_TTLB),
>>> + SR_TRAP(OP_TLBI_ASIDE1, CGT_HCR_TTLB),
>>> + SR_TRAP(OP_TLBI_VAAE1, CGT_HCR_TTLB),
>>> + SR_TRAP(OP_TLBI_VALE1, CGT_HCR_TTLB),
>>> + SR_TRAP(OP_TLBI_VAALE1, CGT_HCR_TTLB),
>>> + SR_TRAP(OP_TLBI_RVAE1NXS, CGT_HCR_TTLB),
>>> + SR_TRAP(OP_TLBI_RVAAE1NXS, CGT_HCR_TTLB),
>>> + SR_TRAP(OP_TLBI_RVALE1NXS, CGT_HCR_TTLB),
>>> + SR_TRAP(OP_TLBI_RVAALE1NXS, CGT_HCR_TTLB),
>>> + SR_TRAP(OP_TLBI_VMALLE1NXS, CGT_HCR_TTLB),
>>> + SR_TRAP(OP_TLBI_VAE1NXS, CGT_HCR_TTLB),
>>> + SR_TRAP(OP_TLBI_ASIDE1NXS, CGT_HCR_TTLB),
>>> + SR_TRAP(OP_TLBI_VAAE1NXS, CGT_HCR_TTLB),
>>> + SR_TRAP(OP_TLBI_VALE1NXS, CGT_HCR_TTLB),
>>> + SR_TRAP(OP_TLBI_VAALE1NXS, CGT_HCR_TTLB),
>>> + SR_TRAP(OP_TLBI_RVAE1IS, CGT_HCR_TTLB_TTLBIS),
>>> + SR_TRAP(OP_TLBI_RVAAE1IS, CGT_HCR_TTLB_TTLBIS),
>>> + SR_TRAP(OP_TLBI_RVALE1IS, CGT_HCR_TTLB_TTLBIS),
>>> + SR_TRAP(OP_TLBI_RVAALE1IS, CGT_HCR_TTLB_TTLBIS),
>>> + SR_TRAP(OP_TLBI_VMALLE1IS, CGT_HCR_TTLB_TTLBIS),
>>> + SR_TRAP(OP_TLBI_VAE1IS, CGT_HCR_TTLB_TTLBIS),
>>> + SR_TRAP(OP_TLBI_ASIDE1IS, CGT_HCR_TTLB_TTLBIS),
>>> + SR_TRAP(OP_TLBI_VAAE1IS, CGT_HCR_TTLB_TTLBIS),
>>> + SR_TRAP(OP_TLBI_VALE1IS, CGT_HCR_TTLB_TTLBIS),
>>> + SR_TRAP(OP_TLBI_VAALE1IS, CGT_HCR_TTLB_TTLBIS),
>>> + SR_TRAP(OP_TLBI_RVAE1ISNXS, CGT_HCR_TTLB_TTLBIS),
>>> + SR_TRAP(OP_TLBI_RVAAE1ISNXS, CGT_HCR_TTLB_TTLBIS),
>>> + SR_TRAP(OP_TLBI_RVALE1ISNXS, CGT_HCR_TTLB_TTLBIS),
>>> + SR_TRAP(OP_TLBI_RVAALE1ISNXS, CGT_HCR_TTLB_TTLBIS),
>>> + SR_TRAP(OP_TLBI_VMALLE1ISNXS, CGT_HCR_TTLB_TTLBIS),
>>> + SR_TRAP(OP_TLBI_VAE1ISNXS, CGT_HCR_TTLB_TTLBIS),
>>> + SR_TRAP(OP_TLBI_ASIDE1ISNXS, CGT_HCR_TTLB_TTLBIS),
>>> + SR_TRAP(OP_TLBI_VAAE1ISNXS, CGT_HCR_TTLB_TTLBIS),
>>> + SR_TRAP(OP_TLBI_VALE1ISNXS, CGT_HCR_TTLB_TTLBIS),
>>> + SR_TRAP(OP_TLBI_VAALE1ISNXS, CGT_HCR_TTLB_TTLBIS),
>>> + SR_TRAP(OP_TLBI_VMALLE1OS, CGT_HCR_TTLB_TTLBOS),
>>> + SR_TRAP(OP_TLBI_VAE1OS, CGT_HCR_TTLB_TTLBOS),
>>> + SR_TRAP(OP_TLBI_ASIDE1OS, CGT_HCR_TTLB_TTLBOS),
>>> + SR_TRAP(OP_TLBI_VAAE1OS, CGT_HCR_TTLB_TTLBOS),
>>> + SR_TRAP(OP_TLBI_VALE1OS, CGT_HCR_TTLB_TTLBOS),
>>> + SR_TRAP(OP_TLBI_VAALE1OS, CGT_HCR_TTLB_TTLBOS),
>>> + SR_TRAP(OP_TLBI_RVAE1OS, CGT_HCR_TTLB_TTLBOS),
>>> + SR_TRAP(OP_TLBI_RVAAE1OS, CGT_HCR_TTLB_TTLBOS),
>>> + SR_TRAP(OP_TLBI_RVALE1OS, CGT_HCR_TTLB_TTLBOS),
>>> + SR_TRAP(OP_TLBI_RVAALE1OS, CGT_HCR_TTLB_TTLBOS),
>>> + SR_TRAP(OP_TLBI_VMALLE1OSNXS, CGT_HCR_TTLB_TTLBOS),
>>> + SR_TRAP(OP_TLBI_VAE1OSNXS, CGT_HCR_TTLB_TTLBOS),
>>> + SR_TRAP(OP_TLBI_ASIDE1OSNXS, CGT_HCR_TTLB_TTLBOS),
>>> + SR_TRAP(OP_TLBI_VAAE1OSNXS, CGT_HCR_TTLB_TTLBOS),
>>> + SR_TRAP(OP_TLBI_VALE1OSNXS, CGT_HCR_TTLB_TTLBOS),
>>> + SR_TRAP(OP_TLBI_VAALE1OSNXS, CGT_HCR_TTLB_TTLBOS),
>>> + SR_TRAP(OP_TLBI_RVAE1OSNXS, CGT_HCR_TTLB_TTLBOS),
>>> + SR_TRAP(OP_TLBI_RVAAE1OSNXS, CGT_HCR_TTLB_TTLBOS),
>>> + SR_TRAP(OP_TLBI_RVALE1OSNXS, CGT_HCR_TTLB_TTLBOS),
>>> + SR_TRAP(OP_TLBI_RVAALE1OSNXS, CGT_HCR_TTLB_TTLBOS),
>>> + SR_TRAP(SYS_SCTLR_EL1, CGT_HCR_TVM_TRVM),
>>> + SR_TRAP(SYS_TTBR0_EL1, CGT_HCR_TVM_TRVM),
>>> + SR_TRAP(SYS_TTBR1_EL1, CGT_HCR_TVM_TRVM),
>>> + SR_TRAP(SYS_TCR_EL1, CGT_HCR_TVM_TRVM),
>>> + SR_TRAP(SYS_ESR_EL1, CGT_HCR_TVM_TRVM),
>>> + SR_TRAP(SYS_FAR_EL1, CGT_HCR_TVM_TRVM),
>>> + SR_TRAP(SYS_AFSR0_EL1, CGT_HCR_TVM_TRVM),
>>> + SR_TRAP(SYS_AFSR1_EL1, CGT_HCR_TVM_TRVM),
>>> + SR_TRAP(SYS_MAIR_EL1, CGT_HCR_TVM_TRVM),
>>> + SR_TRAP(SYS_AMAIR_EL1, CGT_HCR_TVM_TRVM),
>>> + SR_TRAP(SYS_CONTEXTIDR_EL1, CGT_HCR_TVM_TRVM),
>>> + SR_TRAP(SYS_DC_ZVA, CGT_HCR_TDZ),
>>> + SR_TRAP(SYS_DC_GVA, CGT_HCR_TDZ),
>>> + SR_TRAP(SYS_DC_GZVA, CGT_HCR_TDZ),
>>> + SR_TRAP(SYS_LORSA_EL1, CGT_HCR_TLOR),
>>> + SR_TRAP(SYS_LOREA_EL1, CGT_HCR_TLOR),
>>> + SR_TRAP(SYS_LORN_EL1, CGT_HCR_TLOR),
>>> + SR_TRAP(SYS_LORC_EL1, CGT_HCR_TLOR),
>>> + SR_TRAP(SYS_LORID_EL1, CGT_HCR_TLOR),
>>> + SR_TRAP(SYS_ERRIDR_EL1, CGT_HCR_TERR),
>>> + SR_TRAP(SYS_ERRSELR_EL1, CGT_HCR_TERR),
>>> + SR_TRAP(SYS_ERXADDR_EL1, CGT_HCR_TERR),
>>> + SR_TRAP(SYS_ERXCTLR_EL1, CGT_HCR_TERR),
>>> + SR_TRAP(SYS_ERXFR_EL1, CGT_HCR_TERR),
>>> + SR_TRAP(SYS_ERXMISC0_EL1, CGT_HCR_TERR),
>>> + SR_TRAP(SYS_ERXMISC1_EL1, CGT_HCR_TERR),
>>> + SR_TRAP(SYS_ERXMISC2_EL1, CGT_HCR_TERR),
>>> + SR_TRAP(SYS_ERXMISC3_EL1, CGT_HCR_TERR),
>>> + SR_TRAP(SYS_ERXSTATUS_EL1, CGT_HCR_TERR),
>>> + SR_TRAP(SYS_APIAKEYLO_EL1, CGT_HCR_APK),
>>> + SR_TRAP(SYS_APIAKEYHI_EL1, CGT_HCR_APK),
>>> + SR_TRAP(SYS_APIBKEYLO_EL1, CGT_HCR_APK),
>>> + SR_TRAP(SYS_APIBKEYHI_EL1, CGT_HCR_APK),
>>> + SR_TRAP(SYS_APDAKEYLO_EL1, CGT_HCR_APK),
>>> + SR_TRAP(SYS_APDAKEYHI_EL1, CGT_HCR_APK),
>>> + SR_TRAP(SYS_APDBKEYLO_EL1, CGT_HCR_APK),
>>> + SR_TRAP(SYS_APDBKEYHI_EL1, CGT_HCR_APK),
>>> + SR_TRAP(SYS_APGAKEYLO_EL1, CGT_HCR_APK),
>>> + SR_TRAP(SYS_APGAKEYHI_EL1, CGT_HCR_APK),
>>> + /* All _EL2 registers */
>>> + SR_RANGE_TRAP(sys_reg(3, 4, 0, 0, 0),
>>> +      sys_reg(3, 4, 3, 15, 7), CGT_HCR_NV),
>>> + /* Skip the SP_EL1 encoding... */
>>> + SR_RANGE_TRAP(sys_reg(3, 4, 4, 1, 1),
>>> +      sys_reg(3, 4, 10, 15, 7), CGT_HCR_NV),
>>> + SR_RANGE_TRAP(sys_reg(3, 4, 12, 0, 0),
>>> +      sys_reg(3, 4, 14, 15, 7), CGT_HCR_NV),
>>=20
>> Should SPSR_EL2 and ELR_EL2 be considered also?
>=20
> Ah crap, these are outside of the expected range. It doesn't really
> matter yet as we are still a long way away from recursive
> virtualisation, but we might as well address that now.
>=20
> I may also eventually have a more fine grained approach to these
> registers, as the ranges tend to bleed over a number of EL1 registers
> that aren't affected by NV.

I've suspected that, thanks for confirming it.

>=20
> In the meantime, I'll add the patch below to the patch stack.
>=20
> Thanks,
>=20
> M.
>=20
> From 9b650e785e3e59ef23a5dcb8f58be45cdd97b1f2 Mon Sep 17 00:00:00 2001
> From: Marc Zyngier <maz@kernel.org>
> Date: Mon, 21 Aug 2023 18:44:15 +0100
> Subject: [PATCH] KVM: arm64: nv: Add trap description for SPSR_EL2 and EL=
R_EL2
>=20
> Having carved a hole for SP_EL1, we are now missing the entries
> for SPSR_EL2 and ELR_EL2. Add them back.
>=20
> Reported-by: Miguel Luis <miguel.luis@oracle.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
> arch/arm64/kvm/emulate-nested.c | 2 ++
> 1 file changed, 2 insertions(+)
>=20
> diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nes=
ted.c
> index 44d9300e95f5..b5637ae4149f 100644
> --- a/arch/arm64/kvm/emulate-nested.c
> +++ b/arch/arm64/kvm/emulate-nested.c
> @@ -651,6 +651,8 @@ static const struct encoding_to_trap_config encoding_=
to_cgt[] __initconst =3D {
> SR_RANGE_TRAP(sys_reg(3, 4, 0, 0, 0),
>       sys_reg(3, 4, 3, 15, 7), CGT_HCR_NV),
> /* Skip the SP_EL1 encoding... */
> + SR_TRAP(SYS_SPSR_EL2, CGT_HCR_NV),
> + SR_TRAP(SYS_ELR_EL2, CGT_HCR_NV),

Thanks

Miguel

> SR_RANGE_TRAP(sys_reg(3, 4, 4, 1, 1),
>       sys_reg(3, 4, 10, 15, 7), CGT_HCR_NV),
> SR_RANGE_TRAP(sys_reg(3, 4, 12, 0, 0),
> --=20
> 2.34.1
>=20
>=20
> --=20
> Without deviation from the norm, progress is not possible.


