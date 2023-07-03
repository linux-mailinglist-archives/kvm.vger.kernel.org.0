Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF7BB74653F
	for <lists+kvm@lfdr.de>; Mon,  3 Jul 2023 23:59:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230011AbjGCV7g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jul 2023 17:59:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbjGCV7e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Jul 2023 17:59:34 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5A4A187
        for <kvm@vger.kernel.org>; Mon,  3 Jul 2023 14:59:32 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 363G8EUs026226;
        Mon, 3 Jul 2023 21:59:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=upUoZ5kYD/aYk9U3qytD9hff+m5wrgIJLRsRdByTcOA=;
 b=ixgvJglCVMavayZmULWgt0rPp1Gig4ZDfjBL7DM19nbB3SoKwUHb4MPQs0JaBsQRsXQp
 MICW+kVeFhCucMedHTtr03TnGskwWEbgcRcrJ9ntGdhKofOhmT8tc/IIlGeZSpYzK5k/
 8CsS42rWeBjAJuF48mhl++/d+0I2zPDk7+D72i7Zj885DIE9U6zxfWm+UANtEDR63WcG
 3xgYeS8t6NLIm5OF42zVYCsvTEHPihIi6s7CxZYOrV1T5pjoGLw9jzdCA7aPx+rBMfiF
 Q1uwoQNNy63TOAY+qXhAAIw6/e8WqUiL+iZqDnm42lqWWx5Rl3Gu6u/NBcN/zQLieSfv KA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rjajdbhf3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Jul 2023 21:59:14 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 363JjI0i020960;
        Mon, 3 Jul 2023 21:59:13 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3rjak3kqrs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Jul 2023 21:59:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lyaZhSAwW+gTUPHz3HNSao/JEQVkL6DXMsdtY/XsbPQtu5CeFx0SJSbPf3ZlyghVvrWNL7a7wklO7dHK6VBUgLFYUXVUoQi6BQW0NcxjsfXRvlP5VUfaEWX1JDBxk+4ehX/s00Xp5pOZ2SIclnuEfODwExepMo18Wkjh2O+SgPXN8hBijLNaSGu9b90/LQikak5mhaTQZtp1PETiU2Pb2T9AKFB60NvwPDbGtC7PQzcP+/e/PUXQojT5+pSm6jj9csBgH1AxCxPdsx3sBTppl+EzQxpUxfWA/ncnEMvnEd7iaId0vmZVb4n4G0Ir0WbA7zXBIuljfBpLvBWeIGJqFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=upUoZ5kYD/aYk9U3qytD9hff+m5wrgIJLRsRdByTcOA=;
 b=UnFc6yaFY4tFFZrUoD9XysNW/cQ51Kvu8wJZsVZ5YPamXeSCyHuhutWAL8ut8+E/VpW1j9WZn7jn5nSD+CSo8tu7dDqXh4upuw6RJ+4jIrRT2ayUhnz2NW0FVio8LuIBsJ4+cF9u4YlXfzpGxoNmcv4tF9Zc2LE+rEFPmk2gKtIHGMIolrU2oKIx0wC2rwGa08tIjugfQYdPuMCvPiCyJd502hItYj6UxJNuHmBpg6GquQt59QHqBv5rifyThyHdPM5K6xeEz3aDqc9FYLLR6UHypNo6fKyECvOCsIUBy0SQrJpiUYplelDYrEe0pg24FvpN102x9GR+JL3c84S2bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=upUoZ5kYD/aYk9U3qytD9hff+m5wrgIJLRsRdByTcOA=;
 b=muedjnSPnqPbBVbMZ49JoIqT4yd1XrouUBR6KiH5/RD5WQ+Dab+XhjixcRlr/tcKYD7C1LQriHJTZ6og0wEejHhLp2fqw8ASkRV5xteTpSdodwv0PRNYo7ny1Wd/YX3GkeUC+rdMx2DwtxpztaPdPO40v2IFw3mCWu4XBbxa0K8=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by PH0PR10MB7078.namprd10.prod.outlook.com (2603:10b6:510:288::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6544.19; Mon, 3 Jul
 2023 21:59:11 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::96aa:8e73:85a9:98b9]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::96aa:8e73:85a9:98b9%4]) with mapi id 15.20.6544.024; Mon, 3 Jul 2023
 21:59:10 +0000
Message-ID: <e5c13490-00cb-61ba-1f8f-52421140b419@oracle.com>
Date:   Mon, 3 Jul 2023 14:58:21 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH RESEND v2 1/2] target/i386/kvm: introduce
 'pmu-cap-disabled' to set KVM_PMU_CAP_DISABLE
Content-Language: en-US
To:     Like Xu <like.xu.linux@gmail.com>, groug@kaod.org
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org, pbonzini@redhat.com,
        mtosatti@redhat.com, joe.jin@oracle.com, zhenyuw@linux.intel.com,
        lyan@digitalocean.com
References: <20230621013821.6874-1-dongli.zhang@oracle.com>
 <20230621013821.6874-2-dongli.zhang@oracle.com>
 <CAA3+yLdbMwfBQ-3Ckk4zwLdbwNOQ8M28d2CqLP0+AKkDwC7Ynw@mail.gmail.com>
From:   Dongli Zhang <dongli.zhang@oracle.com>
In-Reply-To: <CAA3+yLdbMwfBQ-3Ckk4zwLdbwNOQ8M28d2CqLP0+AKkDwC7Ynw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA9PR10CA0012.namprd10.prod.outlook.com
 (2603:10b6:806:a7::17) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB2663:EE_|PH0PR10MB7078:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b83e4c1-0e31-43f9-57b3-08db7c10bae9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: euhBZR6Wy3PopaCfbnVpee9lA9C1Ox4eD2RM3Vo0EAzNMvJxkpuVnv1k8XPEttwvnwyfqMWctbYBdNbzFodpykjNjy7IyfM75KFpQcAjyOLctx0CF+wXcbj4OwyItB/BGLLbAevvsi41dUUEIH1e/8mT6Iinkr0OM7wq9Fad83gxi9VxTo2RYupcc9mhuwEeYNUDu5q+J0ONJOYCjxUBoZfmWFU7/wqc1DYbGoX32x9Na2Op8whDIvpdICfp1zJcSC9V5SrYg3+lgv4yx1VWX72/kiQo+sk8tfiuYLIu68ATRJbS9DK1Zx9zrLW09xy9R7dgOqsvYFeCapbiyf3TlfxwuWmbtWjCoGAIgEaK2yCJtf0VpvkylWZAXKtHwQCuci6bcU1MCTaSACv4vYHm+QSPeSNUiLbXO8fXOwuPBv90/lCBmnMJLnNJNZl0uMamyAsTl9e9YXsRkpKpqvooCZmbHKsmstN7FQIofmKbXBfDONiDjXOFAJkkoIEjX//I1NhHlso9rcZXqNnEXFvfberXU2LUE4SMKclwnYwILhw1YWn72C+IfJkPFdYza00c+hbfvDjbQCXEnNy5oNAK3+fOFg8XzqcJto4fmaTsOJsx1d1l1PyzGyIxANd1NCXBNUsqQ5M6RCl4pXdBll5HiAzE1tTXQMjvOpYHuLWbHPE7Wja20766KlN66B8f0v06
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(136003)(346002)(39860400002)(396003)(376002)(451199021)(83380400001)(2616005)(2906002)(38100700002)(36756003)(8936002)(8676002)(5660300002)(86362001)(31686004)(66476007)(966005)(41300700001)(4326008)(6666004)(316002)(6486002)(66946007)(66556008)(478600001)(186003)(6512007)(31696002)(6506007)(44832011)(53546011)(26005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WmR5akcvSmxlSFpyWU5UQ0EvejBBQkFzUWVkMmUrZzlTWTVqdVdINWVNdncy?=
 =?utf-8?B?ZjlKTUdkTko1TUJ0R3ZFdXUzN1pZV1pKUS9QWS9rVEdPcG00VlJQYXVhcUpF?=
 =?utf-8?B?QkFpOEgwZlNFYXBFdDNaYkhEMUhwdHBtcElGWVhEcmhCWXVFa3JkQ2dBb2tV?=
 =?utf-8?B?eU1UekhnSlhYZ2lOU2JZMmU4RkRLb1ZZQkpkVHBENk9yb1QweEtjZGhVUzRG?=
 =?utf-8?B?aEJtYmZQbDRmaWhzL2RUYmNHNmwzMmxDSFFjZnBINVVZM1gzbWFBcFozdWI3?=
 =?utf-8?B?eHJJSk5nMFRTamhsQittbjk4RnZXcTZtanpvUW9ZZVFNYnF0NTN0WldXaEg5?=
 =?utf-8?B?MklpdGdmT1ZyalorWnZwcU1kMzdHbDlHWjdwakNPeDRmYkszWnVEU0wyRWxs?=
 =?utf-8?B?V0d4WWc4TUg1ZFNSeHE2Z3A5cFVVRzloelNhb2dwajFDZ2JzMVZQbk9FZzdp?=
 =?utf-8?B?TVFYSXNzdEhZMnhVc2cyZ1pxTThMN3pYbnVCd3pZM2c4NnFmZjdHbHJQV0cy?=
 =?utf-8?B?bHhtUlhRQmFHVE5oQk1Uc0hiUDdLSitBekZoZjB4VDdQTzk0QW9KaDRiSDh6?=
 =?utf-8?B?RDJLV3YrSmV0OFp6Sk9iV1JhTFAvNThScEZybGh1VDZHRFUwR2dqZVIrVVFC?=
 =?utf-8?B?OTcySnlMdWdpY0hFSkhHTE1palJIVnVnSzhNZ3RROWNxSlJTMVcya2FMZXEy?=
 =?utf-8?B?M1VxSHZuMEVvV2Y5UTZPS2wwNHhoVTdMa0k0czVmaXFQblFBcjVCODZWVWhM?=
 =?utf-8?B?NEYvTWY1RVBwWFNmeGswYjJzRFp1Z29QSjI1b0FEWHdtL1JWUVdwOGNSVlBI?=
 =?utf-8?B?WnI3cWp1TElxdFRCN0NFaTYzbHQyWHJVNjUvMFF3OXZ2Vmx5T3ZqTStNeHBI?=
 =?utf-8?B?WW9laUFXSTVvdXhTRmhVMnFLOFg2Zi9FNUNEMlMzMzZZN1oxTUhwOFloMFpq?=
 =?utf-8?B?Tm1ZNmNBN0ZuNXI0blNMSWswMWVXYkVLUHhMUUp2TFRXSUIxeXNYNGx3aWlR?=
 =?utf-8?B?T1FzSUxEOVdVWkFFM1hYVHpiU0liNStrY09rT3RVZ1dYdzJObWhQNDZoN1BC?=
 =?utf-8?B?TXk5RUpPQ2JHNHl2bmFnV0hDb0xNUXR0K1Y5QXdqWFF4Yk9IMWRuR3VWZ044?=
 =?utf-8?B?aHB0M1pjUFdjQkJmTXdtSjZFNnZqVytlQXUyNTVxM2JCS2t1MW42VW1rc1Zo?=
 =?utf-8?B?NTNFWkQ4d2dqaDd5UTZMQUhZZkZ3U1NHWjV5N1pRVFNneGdQY3RqWENHeXBa?=
 =?utf-8?B?U0thazdhanY4UElZSTQ2RXdJVDNIWitNaUtINlRpQmVZbWRjK3BZbXhsNHFj?=
 =?utf-8?B?cUI1clFOYWNvdUEyY1VTano4aG1tMjlqcG82RjU2aGxzZWZQdGVCYlMvdlRH?=
 =?utf-8?B?QkF3eHB6bElkTzZhZ20rVE5GYmF2MjlsSzdnVk5JdVlCVG5YU2kvQTF6ODFN?=
 =?utf-8?B?d2dLejJqbk9PSmdhWEhoQ2t2NkgrODM0N2w0cEg5ZFd4Q0NCN2dtWVdnaVdU?=
 =?utf-8?B?ejZMUUVobytGbHVVd3Z1L2F0YktyaHJaOUtiVTBrMWcxT3pNTWsxWnByMjda?=
 =?utf-8?B?VWR6elNhVVVmT1RNbHZMM2hra2l1MkJrY05kZjRQYWdoVnlvMzFDeGdoY3E2?=
 =?utf-8?B?Q3QzSTJ3UEE5RXVHcmFkZVpsZ1FEOU50cmdSTVR6dXNMUHBBckthQ29KcGV1?=
 =?utf-8?B?M0tIcG1xaTR3aW9xc3VUYmthOEdBenBLMTRBYnNiaUpMOHVuenRyV2NVY1hl?=
 =?utf-8?B?R1N3c09KRFhUMGFsTlU1d0QvWGtrVlAyRnpUMm1hb3g3eVdIY1J4YlBJSG91?=
 =?utf-8?B?MUxUWFFSaVFoR3Q5N3dYaStvNFFObWJ2TXFPVE5WWlMxM0gzUXBrTHAwVy9q?=
 =?utf-8?B?c0VQWGhCbTNXWlFiWHZydXBiYWpkMHZ1QkxWZXpNSE1uUFh0SGRYV2hqR09l?=
 =?utf-8?B?OEF2bnZiL0RWQVU1alp3OXBLd2NqZGluUjFwVUtnVzAzOXd3R1ArTXhaQUlS?=
 =?utf-8?B?U3pJejVXaVd5NHYxUXRRaVg1U0tMclp1ZE1mUmQxNlZaRXIzTFhiOUFwOVpi?=
 =?utf-8?B?RHEwei92OFBqeUMyOHZ1VjZ2cTZiVHlicDZtUjFKWlhWSkJjTEN1OU01TGV4?=
 =?utf-8?B?N01uRWc3dC9LdG5QSjl6Q1REUitFQitTd2I1MnVRL3UzdDhoRlpRa2p2bmM0?=
 =?utf-8?B?a2c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?NDd1aU5pRDBQSVdHTUJ5Vkg5SURCRWo2UFZsemlvTUNWRHpubHROY0diY1VD?=
 =?utf-8?B?Rk8yVGZxTzdqMklKMXJ5SEhYOTdmWU5wRGdLaXZkR2ZwYXJkZ3hwZm1KUkVE?=
 =?utf-8?B?Z1cvZ1gyTmlWOWZxanhqNmVWL29pajE5UG1GbUd0S0RFbUFGMTliZE1oR3Y1?=
 =?utf-8?B?NmhEMFc2amN6Vy9kcVU5ZXZ2MUNTbzJWNGkxZk9rNVRENFA5Y2NIcGt4Mng4?=
 =?utf-8?B?bXQ5RlVoa2RCSVFETTEyemdnTzcrUTdUMk5YdUcxeElIMW5CV2o2VUQ4K3A5?=
 =?utf-8?B?cmJGZTludXgzWkFZZVhKVHBtNUxkNGJBZk9lYjFGVFVwMUdoeTZydW9Zd0hm?=
 =?utf-8?B?L3V4b216V00wY20zTXlHYWZtb1BqMG1GWDdGVkNvM3NJSEJBQlllUDhhYnlX?=
 =?utf-8?B?OG1uVEVoMFUxR1B3cW1KcUNZQS8xUjhyMDhFd042ZThycDdnWGF4VmtwdnAr?=
 =?utf-8?B?VWdxV2c4SFZwbXpyNU9IRGhsaGVmbnVORVJGT2VEaTc0Z1FRVFdtbis3Zmtq?=
 =?utf-8?B?aGlndlYvZWtpT2c0Ui9FNzVXZ2M3aFUzT3VvUkRYdWppS2J0MnpmQWJBQkEy?=
 =?utf-8?B?MUE1SVVwTGFPc1V5dmdMUkFyVi9ZZlFySGkrWkxJajd0dWtwOHB3aGxMa1lO?=
 =?utf-8?B?ZDBzK0ZjVlh2WHNLTVUwWmVXWFduOU1iQmdnaVMwdm5VZW1Nc3dyNXR0QWs5?=
 =?utf-8?B?TjN1azY3VEpxMGtvVVgxWEt0QWhtVEdPZklpdmh6STlZRlNLMjFrTHYva3cw?=
 =?utf-8?B?SWxMVThzNEpJa2p2MVRaNFdpdGlpcFd0bEJ6aUVCcVRqVit4NGNic0NSVm9O?=
 =?utf-8?B?eVZrNFFabmNuYnJkampWeVA3S3BtZEZ2bWpWQnU1RldMOFZpU0J1L3J5WUpm?=
 =?utf-8?B?NksrWElCazhZY0lXeVdCMnNNRFZBNzUwc05EVmR0SGd5RXBaVTE0WGRYU2Iy?=
 =?utf-8?B?NEVOSVpTRmtiakxHYkZsc05jWkk0N1JaNm1wVnhKT0RKV3I0aUdrd1BsTzlS?=
 =?utf-8?B?SzdzZHZYcXJuc254a1Jja1dKODRMQThiNGlLemlRY3ZTbUMzTTNvdFZwOG9I?=
 =?utf-8?B?OTloK2dqbDlTdVprSmhOeVdBT3FORjlNc21ZekZlaS92SG95MmdUS3cvcFha?=
 =?utf-8?B?YnF5a0NvRVVQOHI2SUtUc1N6bUoxMVp3eDhqOFd6bGhldmJpMDdVTE9SZ2FW?=
 =?utf-8?B?cnlQYm5vazl5ZlczQ2ppa08rNjJrTzExV1R0SGMxSWt0dTUzZTR4NUk5TUIw?=
 =?utf-8?B?bU0yd1d0VFAzQmcvdFJ4OEpacnhJZFk2UkNYWEduUFNUMDQxZz09?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b83e4c1-0e31-43f9-57b3-08db7c10bae9
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2023 21:59:10.1898
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sYUmFxLCFdQHQqgDrRWUmgPZ3/bMu5e43UI7AENluhTKMT8gWgMCLQK7VrYmgUIY2TuT+X4oNnoTys40x+jrWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB7078
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-03_15,2023-06-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 bulkscore=0
 malwarescore=0 mlxlogscore=999 adultscore=0 spamscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2307030201
X-Proofpoint-ORIG-GUID: iBEeXjU7yQnn_Qp6Zw_6Zpyl3mqCN98Q
X-Proofpoint-GUID: iBEeXjU7yQnn_Qp6Zw_6Zpyl3mqCN98Q
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Like,

On 7/2/23 06:41, Like Xu wrote:
> On Wed, Jun 21, 2023 at 9:39 AM Dongli Zhang <dongli.zhang@oracle.com> wrote:
>>
>> The "perf stat" at the VM side still works even we set "-cpu host,-pmu" in
>> the QEMU command line. That is, neither "-cpu host,-pmu" nor "-cpu EPYC"
>> could disable the pmu virtualization in an AMD environment.
>>
>> We still see below at VM kernel side ...
>>
>> [    0.510611] Performance Events: Fam17h+ core perfctr, AMD PMU driver.
>>
>> ... although we expect something like below.
>>
>> [    0.596381] Performance Events: PMU not available due to virtualization, using software events only.
>> [    0.600972] NMI watchdog: Perf NMI watchdog permanently disabled
>>
>> This is because the AMD pmu (v1) does not rely on cpuid to decide if the
>> pmu virtualization is supported.
>>
>> We introduce a new property 'pmu-cap-disabled' for KVM accel to set
>> KVM_PMU_CAP_DISABLE if KVM_CAP_PMU_CAPABILITY is supported. Only x86 host
>> is supported because currently KVM uses KVM_CAP_PMU_CAPABILITY only for
>> x86.
> 
> We may check cpu->enable_pmu when creating the first CPU or a BSP one
> (before it gets running) and then choose whether to disable guest pmu using
> vm ioctl KVM_CAP_PMU_CAPABILITY. Introducing a new property is not too
> acceptable if there are other options.

In the v1 of the implementation, we have implemented something similar: not
based on the cpu_index (or BSP), but to introduce a helper before creating the
KVM vcpu to let the further implementation decide. We did the
KVM_CAP_PMU_CAPABILITY in that helper once.

[PATCH 1/3] kvm: introduce a helper before creating the 1st vcpu
https://lore.kernel.org/all/20221119122901.2469-2-dongli.zhang@oracle.com/

[PATCH 2/3] i386: kvm: disable KVM_CAP_PMU_CAPABILITY if "pmu" is disabled
https://lore.kernel.org/all/20221119122901.2469-3-dongli.zhang@oracle.com/


The below was the suggestion from Greg Kurz about to use per-VCPU property to
control per-VM cap:

"It doesn't seem conceptually correct to configure VM level stuff out of
a vCPU property, which could theoretically be different for each vCPU,
even if this isn't the case with the current code base.

Maybe consider controlling PMU with a machine property and this
could be done in kvm_arch_init() like other VM level stuff ?"

Would you mind comment on that?

Thank you very much!

Dongli Zhang

> 
>>
>> Cc: Joe Jin <joe.jin@oracle.com>
>> Cc: Like Xu <likexu@tencent.com>
>> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
>> ---
>> Changed since v1:
>> - In version 1 we did not introduce the new property. We ioctl
>>   KVM_PMU_CAP_DISABLE only before the creation of the 1st vcpu. We had
>>   introduced a helpfer function to do this job before creating the 1st
>>   KVM vcpu in v1.
>>
>>  accel/kvm/kvm-all.c      |  1 +
>>  include/sysemu/kvm_int.h |  1 +
>>  qemu-options.hx          |  7 ++++++
>>  target/i386/kvm/kvm.c    | 46 ++++++++++++++++++++++++++++++++++++++++
>>  4 files changed, 55 insertions(+)
>>
>> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
>> index 7679f397ae..238098e991 100644
>> --- a/accel/kvm/kvm-all.c
>> +++ b/accel/kvm/kvm-all.c
>> @@ -3763,6 +3763,7 @@ static void kvm_accel_instance_init(Object *obj)
>>      s->xen_version = 0;
>>      s->xen_gnttab_max_frames = 64;
>>      s->xen_evtchn_max_pirq = 256;
>> +    s->pmu_cap_disabled = false;
>>  }
>>
>>  /**
>> diff --git a/include/sysemu/kvm_int.h b/include/sysemu/kvm_int.h
>> index 511b42bde5..cbbe08ec54 100644
>> --- a/include/sysemu/kvm_int.h
>> +++ b/include/sysemu/kvm_int.h
>> @@ -123,6 +123,7 @@ struct KVMState
>>      uint32_t xen_caps;
>>      uint16_t xen_gnttab_max_frames;
>>      uint16_t xen_evtchn_max_pirq;
>> +    bool pmu_cap_disabled;
>>  };
>>
>>  void kvm_memory_listener_register(KVMState *s, KVMMemoryListener *kml,
>> diff --git a/qemu-options.hx b/qemu-options.hx
>> index b57489d7ca..1976c0ca3e 100644
>> --- a/qemu-options.hx
>> +++ b/qemu-options.hx
>> @@ -187,6 +187,7 @@ DEF("accel", HAS_ARG, QEMU_OPTION_accel,
>>      "                tb-size=n (TCG translation block cache size)\n"
>>      "                dirty-ring-size=n (KVM dirty ring GFN count, default 0)\n"
>>      "                notify-vmexit=run|internal-error|disable,notify-window=n (enable notify VM exit and set notify window, x86 only)\n"
>> +    "                pmu-cap-disabled=true|false (disable KVM_CAP_PMU_CAPABILITY, x86 only, default false)\n"
>>      "                thread=single|multi (enable multi-threaded TCG)\n", QEMU_ARCH_ALL)
>>  SRST
>>  ``-accel name[,prop=value[,...]]``
>> @@ -254,6 +255,12 @@ SRST
>>          open up for a specified of time (i.e. notify-window).
>>          Default: notify-vmexit=run,notify-window=0.
>>
>> +    ``pmu-cap-disabled=true|false``
>> +        When the KVM accelerator is used, it controls whether to disable the
>> +        KVM_CAP_PMU_CAPABILITY via KVM_PMU_CAP_DISABLE. When disabled, the
>> +        PMU virtualization is disabled at the KVM module side. This is for
>> +        x86 host only.
>> +
>>  ERST
>>
>>  DEF("smp", HAS_ARG, QEMU_OPTION_smp,
>> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
>> index de531842f6..bf4136fa1b 100644
>> --- a/target/i386/kvm/kvm.c
>> +++ b/target/i386/kvm/kvm.c
>> @@ -129,6 +129,7 @@ static bool has_msr_ucode_rev;
>>  static bool has_msr_vmx_procbased_ctls2;
>>  static bool has_msr_perf_capabs;
>>  static bool has_msr_pkrs;
>> +static bool has_pmu_cap;
>>
>>  static uint32_t has_architectural_pmu_version;
>>  static uint32_t num_architectural_pmu_gp_counters;
>> @@ -2767,6 +2768,23 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
>>          }
>>      }
>>
>> +    has_pmu_cap = kvm_check_extension(s, KVM_CAP_PMU_CAPABILITY);
>> +
>> +    if (s->pmu_cap_disabled) {
>> +        if (has_pmu_cap) {
>> +            ret = kvm_vm_enable_cap(s, KVM_CAP_PMU_CAPABILITY, 0,
>> +                                    KVM_PMU_CAP_DISABLE);
>> +            if (ret < 0) {
>> +                s->pmu_cap_disabled = false;
>> +                error_report("kvm: Failed to disable pmu cap: %s",
>> +                             strerror(-ret));
>> +            }
>> +        } else {
>> +            s->pmu_cap_disabled = false;
>> +            error_report("kvm: KVM_CAP_PMU_CAPABILITY is not supported");
>> +        }
>> +    }
>> +
>>      return 0;
>>  }
>>
>> @@ -5951,6 +5969,28 @@ static void kvm_arch_set_xen_evtchn_max_pirq(Object *obj, Visitor *v,
>>      s->xen_evtchn_max_pirq = value;
>>  }
>>
>> +static void kvm_set_pmu_cap_disabled(Object *obj, Visitor *v,
>> +                                     const char *name, void *opaque,
>> +                                     Error **errp)
>> +{
>> +    KVMState *s = KVM_STATE(obj);
>> +    bool pmu_cap_disabled;
>> +    Error *error = NULL;
>> +
>> +    if (s->fd != -1) {
>> +        error_setg(errp, "Cannot set properties after the accelerator has been initialized");
>> +        return;
>> +    }
>> +
>> +    visit_type_bool(v, name, &pmu_cap_disabled, &error);
>> +    if (error) {
>> +        error_propagate(errp, error);
>> +        return;
>> +    }
>> +
>> +    s->pmu_cap_disabled = pmu_cap_disabled;
>> +}
>> +
>>  void kvm_arch_accel_class_init(ObjectClass *oc)
>>  {
>>      object_class_property_add_enum(oc, "notify-vmexit", "NotifyVMexitOption",
>> @@ -5990,6 +6030,12 @@ void kvm_arch_accel_class_init(ObjectClass *oc)
>>                                NULL, NULL);
>>      object_class_property_set_description(oc, "xen-evtchn-max-pirq",
>>                                            "Maximum number of Xen PIRQs");
>> +
>> +    object_class_property_add(oc, "pmu-cap-disabled", "bool",
>> +                              NULL, kvm_set_pmu_cap_disabled,
>> +                              NULL, NULL);
>> +    object_class_property_set_description(oc, "pmu-cap-disabled",
>> +                                          "Disable KVM_CAP_PMU_CAPABILITY");
>>  }
>>
>>  void kvm_set_max_apic_id(uint32_t max_apic_id)
>> --
>> 2.34.1
>>
