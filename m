Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1843225D32F
	for <lists+kvm@lfdr.de>; Fri,  4 Sep 2020 10:04:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729683AbgIDIDz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Sep 2020 04:03:55 -0400
Received: from mail-db8eur05on2051.outbound.protection.outlook.com ([40.107.20.51]:28224
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728170AbgIDIDx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Sep 2020 04:03:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b0KopomZmm3kuzvl01cewLoMRrMzj26j5fChkX0h84QvxQcPEt5BLyBqG60DZIF35CljgQ+rI4X0WbvkeAc8MdkC9PLQ3ZaRTVZ/qUbX1TqXgDhvKpLeiv3tVc3cPQqaq8yR0VKPg21nMAO9yqmRDEWY/adBqEb48hpE+3zqpaMur+0Z5DQLGseHVG2pUHJvQOktnkVFhUSW51Rmvt/kqT061ejni5LC8tb3JP3gyY44ESEP0UqRY/krIs6CvLaP8+L+olE6ZeV10qKvUuF3lCyGJQLz35pAZxst8xtE+geE9EpXS4IzX1WkMertPriddhuW0e2bib0XuDJbmTZjlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N19n63mlBQ7ikIa2ibUOY9oW+ihUmpP9tuCEQKbspos=;
 b=gJxfv+urUOUomfjX/otGFmF0vTmzqK5AZGz/hdr6oIrbhsgI8NJQ8j6UxnsgGh1gb8lt5OopMttkpRYtpOJ1gb7GaEQeMqClWdVSNAHhk/zrR+U6R0kYlwCIhGEW1VTaVHXVO2Btbi27I+MR14kXBHxKe8Yic8FouvQsJXDaTztTLy7tEwART3axfKouYL5Tm2sjh9Dgitge9QQdEQ0VMEF+xWw+jS9KP4shZ+ZkdjjZUBCG/zAGO6uPq11IhGZjXBB8+8NmpOBGdGxnwukDlfIXx+Q64Mb1Ex9ONX/jsZQwnTm5khLiG0hRF3uHL45LO3oMVmdAXkR5P3iAeuj+IQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N19n63mlBQ7ikIa2ibUOY9oW+ihUmpP9tuCEQKbspos=;
 b=hMeYX6UlfvFomR3oJEftZkplxSgG4+VJVHLb4WQFQuHlDXUiWljB5PptvNRUOnShJKIAh1s73V5IghpPYunaEz0SsNY+RvyEYxcM1EtM5n8wmEVcfLEP+/ezEyPph14W2ThCV6+Y9ytL3YZoHuMU4uGNXtsiftrejHOY3YzkweA=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from VI1PR0402MB2815.eurprd04.prod.outlook.com
 (2603:10a6:800:ae::16) by VI1PR0402MB3583.eurprd04.prod.outlook.com
 (2603:10a6:803:e::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.16; Fri, 4 Sep
 2020 08:03:49 +0000
Received: from VI1PR0402MB2815.eurprd04.prod.outlook.com
 ([fe80::a508:19fb:5b7e:5607]) by VI1PR0402MB2815.eurprd04.prod.outlook.com
 ([fe80::a508:19fb:5b7e:5607%9]) with mapi id 15.20.3348.016; Fri, 4 Sep 2020
 08:03:49 +0000
Subject: Re: [PATCH v4 00/10] vfio/fsl-mc: VFIO support for FSL-MC device
To:     Auger Eric <eric.auger@redhat.com>, alex.williamson@redhat.com,
        kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, bharatb.linux@gmail.com,
        laurentiu.tudor@nxp.com
References: <20200826093315.5279-1-diana.craciun@oss.nxp.com>
 <ae46be70-82d3-6137-6169-beb4bf8ae707@redhat.com>
From:   Diana Craciun OSS <diana.craciun@oss.nxp.com>
Message-ID: <084feb8a-3f9b-efc1-e4f8-eb9a3e60b756@oss.nxp.com>
Date:   Fri, 4 Sep 2020 11:03:44 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
In-Reply-To: <ae46be70-82d3-6137-6169-beb4bf8ae707@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: AM0PR01CA0130.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:168::35) To VI1PR0402MB2815.eurprd04.prod.outlook.com
 (2603:10a6:800:ae::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.122] (188.27.189.94) by AM0PR01CA0130.eurprd01.prod.exchangelabs.com (2603:10a6:208:168::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.15 via Frontend Transport; Fri, 4 Sep 2020 08:03:47 +0000
X-Originating-IP: [188.27.189.94]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d90a27ba-b716-45f1-a94d-08d850a90dee
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3583:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB35834D7FA9BAE52471D14F9CBE2D0@VI1PR0402MB3583.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jbsgBcjli9k5NzwZJ7bO/Fc/pZJxzjbV+4xgadkGXuWJMXexcSKlI6NGNhFLZ/nLMpuf2v8cPYA7JHPNuISz0zM93Gpyx+5YviOyFF7Dj3Q0QVjFTn3S2zoSAt4mn/YTV9ITLkCW0Mooz+Mg+WwJEXjmOfgNia9NsKI43PGy/QHTniIEgq9k7J/brKbcA949HW0RA7DLjqUqGgg45RXWYOOm21iBHFNe3jTZP/e/W4qauyM3YsugUVPxLAvAVyasCtBxjGBDiHTOTaIeKEHrJWJGhsD19mjCWWIgQ1pOiMA8rCk5//bH1Dzq/YaUc3YXnyQu7FZwdaD62fA+0eA1vC76sslZynZ9OcwWD+I3aHzWENvy/m+frQSdJwG+IU16E7dsbRXUHsAsVWSHFLnv69AoyjFCLyGbHnLBtSJti3FhDqMBbGZ0VBxtkRfo2Uus9JgKywBp1DGKwE9QcZN1NQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB2815.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(366004)(376002)(136003)(39860400002)(2906002)(16576012)(52116002)(66556008)(53546011)(86362001)(4326008)(66946007)(31696002)(2616005)(31686004)(5660300002)(66476007)(83380400001)(956004)(186003)(8936002)(6666004)(478600001)(6486002)(8676002)(4744005)(966005)(26005)(316002)(16526019)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: JOhJJtfJ+bWmg/0Y+T1nteiBz1sXEyxnSd21rp5beuycH+oU6wuGCWtSPRzaqi3Jx4k19lDES7ck0YH9C1w/qHk1a5zUtYrM4JWg7q84yDR0VwE9yBVlSDY26kp28PVlpiGOQlFdN3gCwZfSjjc83HXQdNjlYDAPWqWr40lgqo84D7Y12oXGnPeZ83JQ9Uz1aHFt60J2MxGLciIwWPjZcy3Z8twU/RmShE3Dwh/pYaF2w2Lzlalo8n5w3vLrkFhSCmZyMTTAtxTZGQOf9Kv1aC0lIL0pbPXKucoGBqDaNRv3fIxQvN6ORs2RkgCBVaI00pcOg/Xw4KLOsJ1emU/zybZrmtvbpS1bSk8sEziL3LXXfWmNIg81jFZxf6muJmUEmz5YIPVdaZcJSIX9Q+nhCMM80fNSSIKA1RTk/Tzubp/l8DHDfV47OEoyRkJpRetnVXkCp8K/ajWDxggR762e0ETYvgcv2XvXMUXLiAuIg8zN79f5dqPBMutVb5yyEAiTrps4+P7mhRzy9ckWvVE27T3PeQhINOYVWYa/M2x9cFqR1QTK9WtJqpUJOruyvB9xET6HQ04aAFeBbN32hfAlQbm+UNaZbD3L4vPBXScda2QtCEfCmLImLMlu8vukBCsd2+Ng9cRQK6TaSY6mbx0N/Q==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d90a27ba-b716-45f1-a94d-08d850a90dee
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB2815.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2020 08:03:48.9153
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TJenP7JIf5kQ7rI3nlh+w+kBZ1ZO3uZ3nvZ+//KD3WcNTFG8d4V/I7BlAZkxoIR2a5f7xsZRjl+O3YSRFt/LSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3583
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Eric,

On 9/3/2020 4:40 PM, Auger Eric wrote:
>> The patches are dependent on some changes in the mc-bus (bus/fsl-mc) 
>> driver. The changes were needed in order to re-use code and to export 
>> some more functions that are needed by the VFIO driver. Currenlty the 
>> mc-bus patches are under review: 
>> https://www.spinics.net/lists/kernel/msg3639226.html 
> Could you share a branch with both series? This would help the review. 
> Thanks Eric 

I have pushed both the series here: 
https://source.codeaurora.org/external/qoriq/qoriq-components/linux-extras/log/?h=dpaa2_direct_assignment 


Regards,

Diana

PS: I apologize if you received the message twice, I have sent it by 
mistake as html first.
