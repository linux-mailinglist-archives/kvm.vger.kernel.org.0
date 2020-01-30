Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78D6614DDCD
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2020 16:29:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727197AbgA3P3R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jan 2020 10:29:17 -0500
Received: from mail-vi1eur05on2092.outbound.protection.outlook.com ([40.107.21.92]:42688
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727158AbgA3P3Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jan 2020 10:29:16 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FpdrCywi/uNJ/XZw9EWueyinMxpv8GLGBjwN6kMCWJktx7k6Gz3GHgcm6hBMU/o1I29SUcFLMAZnaOzCNG2nQcBjsFM6qDURUxLFKx0Q0qLwGk8x0NE5C9LLomFcNTwP7i2Trl6gqZPmgaMK2ad31IlRK6v6vo3QUtL2e1VPBlD02ZtIMkYB7c6z3vCbAjcWqQErEWTCQ103trVKJ8I0YRI6PhEzHxc/XwroaBLS6U4ns4oNTXBG921LoXAhWXKQM1uJbI1LZWiS7BxCKP2s+MzRNvq9zid4HKLqLHhatmoHAZ1+6t/CsbhhDjNqPf1YsJxKyM5a+MyISaCmiLtsGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tOIiXK5hj1Rk4HFhYsj9Ot1Tsoqnzuu2IBAI+auvyqk=;
 b=RZaGUb7wdLw/+cLwgSCDo2Lo02LU5I+9+PpjEKGpcgDAahszOv2xMZBG7Z6gCE56UbTjvqdGeirb0+zdeYZe1u1U2HZG4kX0KtzelKHQs5SaA3dIvDUotYLozr2tj4GGEdAlttYCBt45xXsvjlvkHHB2xrNCJ5JjCq7X1OrfdOTZfz10PoOAqHfovESYeWyCIUge0dR6EgovpDePpU2oPPgV1nqqK/Is4G1PzmwDAHE8QILfodqgIeiqLJ2NVSuPo45DckkaO9dyPQrvFCmMglkja1n944ag/RX5thPdziEM/TY6C9C44/YDI6eZMz1Kyella9lXrZrMAZlbJraM9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tOIiXK5hj1Rk4HFhYsj9Ot1Tsoqnzuu2IBAI+auvyqk=;
 b=iO2SHgoEtXzFGjxPsXCNOb17tqa6Aqr/hNLNiRk+eGdFNwu/2NLdO8Z1DQ3k5hBW7NOgeVQOVbgipF0n9QyXLbQWX9Hg4P85fwGvr/hDgiBP58XPc6okm/GMmzhHcqTbrhWt62SLlwLluabLxvqLlFRm7rbRrvdNfLw4cWJpBWk=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=vsementsov@virtuozzo.com; 
Received: from AM6PR08MB4423.eurprd08.prod.outlook.com (20.179.7.140) by
 AM6PR08MB5112.eurprd08.prod.outlook.com (10.255.123.81) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2686.27; Thu, 30 Jan 2020 15:29:14 +0000
Received: from AM6PR08MB4423.eurprd08.prod.outlook.com
 ([fe80::11a9:a944:c946:3030]) by AM6PR08MB4423.eurprd08.prod.outlook.com
 ([fe80::11a9:a944:c946:3030%7]) with mapi id 15.20.2686.025; Thu, 30 Jan 2020
 15:29:13 +0000
Subject: Re: [PATCH 00/10] python: Explicit usage of Python 3
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        qemu-devel@nongnu.org
Cc:     Stefan Hajnoczi <stefanha@redhat.com>, kvm@vger.kernel.org,
        Kevin Wolf <kwolf@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        Cleber Rosa <crosa@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Max Reitz <mreitz@redhat.com>,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        Fam Zheng <fam@euphon.net>,
        Michael Roth <mdroth@linux.vnet.ibm.com>,
        Markus Armbruster <armbru@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?Q?Daniel_P_=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        qemu-block@nongnu.org,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>
References: <20200129231402.23384-1-philmd@redhat.com>
 <0a858225-685d-3ffd-845c-6c1f8a438307@virtuozzo.com>
 <c90ce40e-428a-ed5e-531f-b2ca99121dfc@redhat.com>
From:   Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>
X-Tagtoolbar-Keys: D20200130182910987
Message-ID: <ba8cf924-39fb-7f7b-40a2-204026fd1a63@virtuozzo.com>
Date:   Thu, 30 Jan 2020 18:29:11 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
In-Reply-To: <c90ce40e-428a-ed5e-531f-b2ca99121dfc@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: HE1PR05CA0382.eurprd05.prod.outlook.com
 (2603:10a6:7:94::41) To AM6PR08MB4423.eurprd08.prod.outlook.com
 (2603:10a6:20b:bf::12)
MIME-Version: 1.0
Received: from [172.16.24.200] (185.231.240.5) by HE1PR05CA0382.eurprd05.prod.outlook.com (2603:10a6:7:94::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2686.27 via Frontend Transport; Thu, 30 Jan 2020 15:29:12 +0000
X-Tagtoolbar-Keys: D20200130182910987
X-Originating-IP: [185.231.240.5]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fbe134b6-f6ed-4a84-9aac-08d7a5992937
X-MS-TrafficTypeDiagnostic: AM6PR08MB5112:
X-Microsoft-Antispam-PRVS: <AM6PR08MB51126E6A2DE8BD0A92A3366BC1040@AM6PR08MB5112.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 02981BE340
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(396003)(136003)(376002)(366004)(346002)(39850400004)(189003)(199004)(86362001)(8676002)(5660300002)(31696002)(16526019)(26005)(8936002)(186003)(81166006)(81156014)(66556008)(66476007)(6486002)(66946007)(7416002)(966005)(52116002)(316002)(16576012)(478600001)(54906003)(2906002)(4326008)(36756003)(53546011)(31686004)(956004)(2616005);DIR:OUT;SFP:1102;SCL:1;SRVR:AM6PR08MB5112;H:AM6PR08MB4423.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: virtuozzo.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZC/ZQzqKtGAd7Coe/XLQhIZN9xHSp8KPhkdzo1WXjQdWG3ywAWcI2uNT3Zf3o0uXufu8TOjpu1o7SOnq8ixAnDNkeiM1FTytDH2qdtQ9SXRny1zIBY+1qtgbJOEKwgyBWVSLpzflTF/lnKtXfiqNzpnnNKLbnpht0cRcYjotSXuTktA1U+1MoqwI2O7pHBtBMvXZlxESPLgEVBrYh6QtvTboI3sZogP6gSwDCRQQWT442S/ZujoS1ziRyk6fLSCgW2EOiKTXjphR3t2f4iox1mYz4L++r9gy3qkrRLoTpMIOxkDqLhbouxSTpbhhAbCHVpZBSto3EozPQ70zKdebTv2OsWkvIGXWjTQFRUYvi9Fhp8d7EV5AedEIdtFx5M23rlGggodq5X6cn2XE2pnpDHe3O0ixtZ35QVnSZ7ZiIKG+k8iDvWp9JIBF7g385DAI+tcWtOH/wBYXfDr7sTzn8wVwHlir7PSecMUSFsJwT+jOq/dZ8sDDcJAMBZmcUaJ5OShavQ5wA/yCJSDRPlHfHQ==
X-MS-Exchange-AntiSpam-MessageData: lNpIDRkLZOm+tlu4Pj7mwmH0XZw+J8RvODaMk07vsG7iAW0p7nSN1ZNAyps6jhSYSRgSFdOK+ZN6v7wpn5eqF3pPaUuSJP1iFa3+EaE+12iH6aUfE+jbPeyYk497NhxbTIaqHzC04ZRqgjnxCznbFw==
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fbe134b6-f6ed-4a84-9aac-08d7a5992937
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2020 15:29:13.8052
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cXhmU41pAv2Dc9DxPvc3StpY6hzBd+3Vb8HDu/PjcVvV67y9VGIxuNBdBylxUMjFKWLNT9NCDCgDM723aV6IQa7ZjKDRSA6GjyzUDGGeKTs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR08MB5112
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

30.01.2020 18:04, Philippe Mathieu-Daudé wrote:
> On 1/30/20 3:02 PM, Vladimir Sementsov-Ogievskiy wrote:
>> First, thanks for handling this!
>>
>> 30.01.2020 2:13, Philippe Mathieu-Daudé wrote:
>>> Hello,
>>>
>>> These are mechanical sed patches used to convert the
>>> code base to Python 3, as suggested on this thread:
>>> https://www.mail-archive.com/qemu-devel@nongnu.org/msg675024.html
>>>
>>> Regards,
>>>
>>> Phil.
>>>
>>> Philippe Mathieu-Daudé (10):
>>>    scripts: Explicit usage of Python 3
>>>    tests/qemu-iotests: Explicit usage of Python 3
>>>    tests: Explicit usage of Python 3
>>>    scripts/minikconf: Explicit usage of Python 3
>>>    tests/acceptance: Remove shebang header
>>>    scripts/tracetool: Remove shebang header
>>>    tests/vm: Remove shebang header
>>>    tests/qemu-iotests: Explicit usage of Python 3
>>>    scripts: Explicit usage of Python 3
>>>    tests/qemu-iotests/check: Update to match Python 3 interpreter
>>>
>>
>> Could you please not use same subject for different patches? Such things are hard to manage during patch porting from version to version.
> 
> I can change but I'm not understanding what you want.

I just want different subjects for different patches (you use the same for 01 and 09, for 02 and 08), if it possible :) But I don't insist.

> 
>>
>> Also, will you update checkpatch.pl, to avoid appearing unversioned python again?
> 
> I'm not sure I can because checkpatch.pl is written in Perl, but I'll try.
> 


-- 
Best regards,
Vladimir
