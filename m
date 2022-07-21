Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3013757D197
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 18:33:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231448AbiGUQdE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 12:33:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbiGUQdB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 12:33:01 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9084474DB
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 09:33:00 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26LGN0oi016431
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 16:33:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=W5RrzL7hHHUzdu3/ULoC7i2WMzg1N1aFv/a6Gwixpeg=;
 b=tC0FIV2Rl1XyvB0e99x33wlyoSoC/7lGHWriPefsblI5vDhRT2ZZHRHekW6pUiMgLdjy
 Oy+71IsOaAwbP6xYCLAIshX/UEXao6dkXsDMEyyLHKsfCDd5btMteQnGoSpjW5vx8MAV
 Fc0BvOc9yc4hsyQNAzlA5BJz/fVMZ+kR1d2h31DqVqfn8ZvxVkOh1CnbT8pDSCRxqvtq
 G1pEkUyPYmZbKAt6GzbId5YhvlZV0yYt1AMgLGMP+YcraWwldYklWFdl6s3XnXm+oaXX
 /C483sey78hDjmwz4lUrG9Zqo5taSHIE0E36FcM0fM09IMVhcebW1a+qKeT1pqn/XfTY BA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3hfa98g8nh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 16:32:59 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26LGNErC017876
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 16:32:59 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3hfa98g8n2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 16:32:59 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26LGJUhp028301;
        Thu, 21 Jul 2022 16:32:57 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03fra.de.ibm.com with ESMTP id 3hbmy8nfc6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 16:32:57 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26LGWsOD15598050
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jul 2022 16:32:54 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 37E984C044;
        Thu, 21 Jul 2022 16:32:54 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EC4474C040;
        Thu, 21 Jul 2022 16:32:53 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.4.232])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 21 Jul 2022 16:32:53 +0000 (GMT)
Date:   Thu, 21 Jul 2022 18:32:45 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v1 2/2] s390x: create persistent comm-key
Message-ID: <20220721183245.36b9d126@p-imbrenda>
In-Reply-To: <20220721132647.552298-3-nrb@linux.ibm.com>
References: <20220721132647.552298-1-nrb@linux.ibm.com>
        <20220721132647.552298-3-nrb@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: WwANERIEPvuX8XFaaSvTyUsX3FG1EqCW
X-Proofpoint-GUID: vJYp8JQryON3fWR4hZWLfziFzawkJZy7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-21_22,2022-07-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 bulkscore=0 phishscore=0 mlxlogscore=986 spamscore=0 suspectscore=0
 impostorscore=0 malwarescore=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207210061
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 21 Jul 2022 15:26:47 +0200
Nico Boehr <nrb@linux.ibm.com> wrote:

> To decrypt the dump of a PV guest, the comm-key (CCK) is required. Until
> now, no comm-key was provided to genprotimg, therefore decrypting the
> dump of a kvm-unit-test under PV was not possible.
> 
> This patch makes sure that we create a random CCK if there's no
> $(TEST_DIR)/comm.key file.
> 
> Also allow dumping of PV tests by passing the appropriate PCF to
> genprotimg (bit 34). --x-pcf is used to be compatible with older
> genprotimg versions, which don't support --enable-dump. 0xe0 is the
> default PCF value and only bit 34 is added.
> 
> Unfortunately, recent versions of genprotimg removed the --x-comm-key
> argument which was used by older versions to specify the CCK. To support
> these versions, we need to parse the genprotimg help output and decide
> which argument to use.

I wonder if we can simply support only the newest version?
would make the code cleaner, and updating genprotimg is not too
complicated

[...]
