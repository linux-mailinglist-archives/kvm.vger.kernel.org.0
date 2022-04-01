Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2D414EFD42
	for <lists+kvm@lfdr.de>; Sat,  2 Apr 2022 01:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241797AbiDAXwL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Apr 2022 19:52:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232747AbiDAXwI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Apr 2022 19:52:08 -0400
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2BD233899
        for <kvm@vger.kernel.org>; Fri,  1 Apr 2022 16:50:18 -0700 (PDT)
Received: from pps.filterd (m0127840.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 231LWwwP031070
        for <kvm@vger.kernel.org>; Fri, 1 Apr 2022 16:50:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : subject
 : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint20171006;
 bh=acd/uA7GerXWHMHGlqFvfwA1L3ncv2ff0XY5waav5ps=;
 b=Lt7WMJ6E3YGfxNy9ulbTJOwdEGPTJpHTWUteAi/ZfjUxcLYn9NLnI3r1DcOY6yf8hzMN
 qFIBQ2LNAU5weF7Rzo6g9layCPVrNeCTdwbkIlDDNczxfB5qDB5++kziUCR+p5dfAJVs
 cjJk1LznncOtcd1N7b+h0N415vPa0RVS8UEXkMi2O3/9RaCPu0iSPGT+VL2p5BBf86Li
 5+zEjfrZClfeGc5tmmnD3gy0XBvOHBTOwkffQUsxHM3FRPGku8UPmb69qaBV2I0thowK
 wGZj8lEIxAjjGG6Q9fGI9j8LCpE81b5oD5MQIVSYbHC4cpmm0O9HramULEiAZXAJ6MUc zQ== 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2106.outbound.protection.outlook.com [104.47.58.106])
        by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 3f1y5uxwen-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 01 Apr 2022 16:50:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fknCU3Fg/uilfi+53U6TV9JJ7T9BYlx0etbxeldkxZNLBABoWnm5hOWPFWn8IxNPx08N+lJkV1pcHyZOmLen17m7JtEcF6IN2JnI/VZeU5USNXRB42oM6IO97flJmWkHj4Z3GYi5CkQD3hudOoCLNxKWfM5h2Z5iKEyTsrJh5ikCSdoaaflbKXVgIW5nwL5sAPNwqs50zf8bLG1IyokduXZL7rXi5FgLMcwmAb62w1//owElah9Zd685Qn21bM1mUufSXPPfIBtI4WhX21/VpBvkwZv+qmC9wxmTQOw6IFdwlQMSdE5EAOq8oVQl3g90fW1wloxY/KCvnfGmj6MGPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=acd/uA7GerXWHMHGlqFvfwA1L3ncv2ff0XY5waav5ps=;
 b=M+2dUzIp16VdyO1GvHVYjiYCLhYGeNKGbE6jw2Ye2PsegLBA/ojQhPk9rJfFhA/+I/8EFl/kC38gLtKHzZ6YOzxbJAhdkP+qhpE08iZJV74NTetBBWb/WBUKVvVfkKnCJLnQxvP1tNLiIwli0nRj7WZ1AiupPuqGSZpuWxYrt90MZdwlpNeBWoBmGXqZX1RVUyTlPnVjrOvBzrNolZoJpgappgWw1ZldZuGnA5Qsp6gRxFj9+01i8PxfmB1x1jh6Cq4OcF1w+mYRzGyjHZcJZz8OHtk2za/jwsX8GjNbBPkU8AfzDqhsPvQ8V1+6yDok7sAAA7Ger3/POB5HbNYcVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from SJ0PR02MB8862.namprd02.prod.outlook.com (2603:10b6:a03:3fd::8)
 by CH0PR02MB8178.namprd02.prod.outlook.com (2603:10b6:610:ff::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.25; Fri, 1 Apr
 2022 23:50:16 +0000
Received: from SJ0PR02MB8862.namprd02.prod.outlook.com
 ([fe80::3580:8973:41bc:fe63]) by SJ0PR02MB8862.namprd02.prod.outlook.com
 ([fe80::3580:8973:41bc:fe63%6]) with mapi id 15.20.5123.021; Fri, 1 Apr 2022
 23:50:16 +0000
From:   "Kallol Biswas [C]" <kallol.biswas@nutanix.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: General KVM/QEMU VM debugging techniques
Thread-Topic: General KVM/QEMU VM debugging techniques
Thread-Index: AdhGIiBU/oPaJn0wSrKBNx35pj8t/gAAQ3jw
Date:   Fri, 1 Apr 2022 23:50:16 +0000
Message-ID: <SJ0PR02MB8862328DCA089E7B5699B927FEE09@SJ0PR02MB8862.namprd02.prod.outlook.com>
References: <SJ0PR02MB886210F928C7CD01DFAD5FD0FEE09@SJ0PR02MB8862.namprd02.prod.outlook.com>
In-Reply-To: <SJ0PR02MB886210F928C7CD01DFAD5FD0FEE09@SJ0PR02MB8862.namprd02.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 03d2e101-39c4-4bb0-1e1d-08da143a5f61
x-ms-traffictypediagnostic: CH0PR02MB8178:EE_
x-microsoft-antispam-prvs: <CH0PR02MB8178F15DB70DBBF9420FD653FEE09@CH0PR02MB8178.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 120dD90610C5xR640NRAfg/wYfJBVY0/intPs0tNNqotx11d4ukO/N8GnqhbTT/oMTQt1BRSFFZQO19fkm6SvBIF/Hbni8M8ggkIwpRnu7tLzxwic+AFf/3MACTRhYeF/dEPMJQPDiIdM71NV97fSdJjdWELQgU3ffts1v30VJzcMWvAImNH6xjTR9MTEYCfwxl7Jp4ExoD91LnuUXOByDTBS9pk3bmFlXiGw1UDyvMIJzu5nGWi6Q7kwsanzAIc6e/wWJo+JDG2lBNlaW1qgiXGr3Ot95LfcE+DfVeQG10MEeSO9q3ed1JcqnesUhVZihYkdPxFQe3um/3a872jreovGT0T+/jR1m/nl0rIVz663AZ/j84QB+ironL6Jnw2BHaARvFGZgpK05ecC/G7RQG1Y1wRL/xlTUiOARyWgaIoIrK7HLgXYplGPOXMXZYZfRF9fDI69AXhCmfrsQOyhb+x6L6wOSk7QkZhJ/qOVcfbffo+vz0vxfWF55RTT3V/aNLOS5avYz8EpA9zaHSPMxFAjxWweDbJdCBLBiEALJQwXFfzh7/OYvLQcqDCauiFEcMYzgKNbyk+WNQGY61tuhgi3cxD0ZepwHEp2xPjuPwCUqi4IlkMawa0Vlg9q+GdCKj6bVtxRDk8W4X/XXHpqOyBj5NwYhQ5wxqFCFGA89axAadfFhXHEoK/oSJLtwNhYsA0p6ABFo4Ih7tIEazeYWC79raGfB6r97aL1jYm0hFZbi38Jz8cwBFZl8NjRxVlZpAdoghjOrj6MFFqcGd+JPPrUQ1Jyzv97UZdbf9Rw4E=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR02MB8862.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(508600001)(2906002)(8936002)(71200400001)(6916009)(5660300002)(55016003)(966005)(40140700001)(33656002)(52536014)(38100700002)(186003)(66946007)(76116006)(66556008)(66476007)(66446008)(64756008)(26005)(8676002)(4744005)(2940100002)(122000001)(9686003)(6506007)(7696005)(38070700005)(83380400001)(316002)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?UpNGQ0GhZWCpJtDJAPQdKlZQgiDPjNg3Zc9VmGpoCCYancMmxCOyDdB33y?=
 =?iso-8859-1?Q?Ee0p3QO/bROOeforXlhNTkXhVUps/es6jLXeXXPCsB9hCrUUju6vkvID8b?=
 =?iso-8859-1?Q?doz10WQHY/WyTe8fM3Xi9Qx04RUV42Oua04N4hGDYdJ6uhL78wDH7hzQkv?=
 =?iso-8859-1?Q?XwsyP9SgHR3KFJtJOSm3HrLpyLuDhNYs075N8KxFjn7BF+2nUXYcFmv6p7?=
 =?iso-8859-1?Q?I5fvkuHvOkO6/r4wPm+bdMJxyU4YXGepozCkA995FVxyij7EQkkgX3JJCp?=
 =?iso-8859-1?Q?HXfH2ZNedyr9Y1sZVi8mz3PdtwsSGyfkyB4ryJZdMJ6ZWweP1oHTDRdoVY?=
 =?iso-8859-1?Q?9BU7Q9OqCHx1aR8nYIN/5h0A3N5aFXmKEExwpoQRzmuKRCw/UpPGOSv5Yq?=
 =?iso-8859-1?Q?dy337CUpmtt+x86oc2vT0oqZbxU5pPt7lWTnuEOLW5acn6qjdRJ+zOG0sK?=
 =?iso-8859-1?Q?UzrNSlYtEhpCq8TTevIU1uqqFYDk78N7SzJC8Svl0KBUHAyHJcUTtngbtn?=
 =?iso-8859-1?Q?UILCido/CbOHslCiuq7jTdZuw5uI1KST8Ptx2t7nWE6m5A8woHKGc7kOwp?=
 =?iso-8859-1?Q?SW/qrnRIp/JXrxXse/99Uc4tPWMwrFLPu1yY2e6Cqg/3+QoFDw+bfMw/rk?=
 =?iso-8859-1?Q?dwhb+NlEJX1gz2ryIzrXlZRyXiGK9YjFe0WjjCPA2G11iGJSix+Tv1FKnx?=
 =?iso-8859-1?Q?FAF4IfLyqIWhyzgKQ895imCICYzGv5StTbG+e+IM9M4WbzWEfhdp6v9HHC?=
 =?iso-8859-1?Q?sJ2bq/keARKLHNZw2FlNvrioonk9bnT6m++cX0oGWgeiMDA/E7AjIrKQx+?=
 =?iso-8859-1?Q?GzKb6yXsGS+6E4uWM+CyBEfUSKbyQoJfeyUHVEEgVU8+4AU8OPn2lctl2g?=
 =?iso-8859-1?Q?O/57I/qds5R2JQyeEZNa0MDR4d2OoK3piXJcTFuN1Q6xoSiPxG2gbGR7od?=
 =?iso-8859-1?Q?Hzf75QDjelF4yiC9iieUVQSmZI2i4wJvrVH2pankE9VDiUpqYFL0Q/cl3r?=
 =?iso-8859-1?Q?Gg2VXe+ccUJQDam9A/IxDjTe7r297mdbYT+edWDLyWgHgy/rd7a34cFoAA?=
 =?iso-8859-1?Q?I8KwBUkmK4W00TBuJZ0HNmZerhvVne+Rg6yZz8ZFC2MFlClP8lZnp7IwEK?=
 =?iso-8859-1?Q?KsWgKfBz0Vu4VV8X0yy2PdZzG6SqSsdVih2xicVqRsfhhc5F1M73Kv0zF3?=
 =?iso-8859-1?Q?hZXn55kjsJVVvbwWD/pEvVaxMfQ4Tko2nqSWbTVK9hbTkadpRYkzISCZqj?=
 =?iso-8859-1?Q?Vl87HYz4EXXMXAJbMvr8oCXx2fauvaDi35aF8530StmNAIGjRsb1Ono9v5?=
 =?iso-8859-1?Q?uBkCiYHZnM4IMH3etx2RXu/4iQoCFw0Tja4fi7D7RDfX0ECghV/umKsLuW?=
 =?iso-8859-1?Q?pPGHNDd5pjjSDljb+LnIcFXOReR+CXSBrXkBASOXzxFVXGccH3knuioBKO?=
 =?iso-8859-1?Q?jq5BEWNKGs2wXNAK/QaeAixVTzjheXv9AYnk6ve++WiVhWZOSqaXRhWldt?=
 =?iso-8859-1?Q?H9PbnfWACqQ2QINnGepYx0m8k0dBQuuoF8PjoLOfTHMhVW87FeAMRi9VYc?=
 =?iso-8859-1?Q?tzOSXbQrJRIpVVFmwxZLBjdmIMZNkC1MFi092XN4S0AqRHe9qVs3b82b9/?=
 =?iso-8859-1?Q?0VqAiodUZkgCWk1xiAM2fMR1i9lVUWgh9a4JDvn6aVowlWJy2Mumut10M+?=
 =?iso-8859-1?Q?O3BfWAmXfzyURTq4ZRhLpFcVLaRnrf5+QgTkpN58NuePDeDyUDFZkiNTk/?=
 =?iso-8859-1?Q?XNlE/T6mqaNhMAbBXLrwGwFVDvIxDtlAC4twgk4fVJTwKrsNwPrgbcJ/mu?=
 =?iso-8859-1?Q?O4H8I6voC23pM1Q4/Ymh1bN9ZcjEMwo=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR02MB8862.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03d2e101-39c4-4bb0-1e1d-08da143a5f61
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Apr 2022 23:50:16.6580
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JnzacX4P4t61ttxh/DPqWiyH0qYHa0W+mWT9HDr6GauQ/nfI9blCIeiTnay/pGiCTl1zw5RVQQ0O1VggLKK0Jen7ecKLWHx8v1dLCjPGWK8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR02MB8178
X-Proofpoint-GUID: unagIuSpBAxmWs2HLOvmVpo4gitCorGo
X-Proofpoint-ORIG-GUID: unagIuSpBAxmWs2HLOvmVpo4gitCorGo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-01_08,2022-03-31_01,2022-02-23_01
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


Hi,
=A0=A0=A0 We are observing a problem with CPU hotplug.

If secureboot option is enabled under UEFI =A0and then if we try to do CPU =
hotplug the VM crashes/just reboots.

No crash dump is generated, no panic message, just VM restarts. Issue seems=
 like:=20
https://bugzilla.redhat.com/show_bug.cgi?id=3D1834250

What are the debugging techniques we can apply to halt the VM and examine w=
hat's going on?
VM has been configured with crash dump.


Nucleodyne at Nutanix
408-718-8164

