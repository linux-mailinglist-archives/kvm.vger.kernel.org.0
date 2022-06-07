Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBEEA540403
	for <lists+kvm@lfdr.de>; Tue,  7 Jun 2022 18:44:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345159AbiFGQoF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jun 2022 12:44:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243262AbiFGQoD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jun 2022 12:44:03 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3BC8D4101;
        Tue,  7 Jun 2022 09:44:01 -0700 (PDT)
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 257Gfhfo004738;
        Tue, 7 Jun 2022 16:44:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=2iwjdWduqgK3lsZmbb5wJE2YzlVqWQhPV9hFXiQaQBs=;
 b=e8v3xAhd8KufW1WOUiiqbKopQ3qUPiBJH0enMR8JYcVfvoenr5PLAQ4r8NHB2/8mPIVy
 ylvAeVeLzoWCSVTi26iIAd8kshsaxgj18MdqnzBXIx77JxX+XWHWTNz6aT6erA2V511e
 7xxhdqW7z4wZgWYY2Yn88B5kgKq22jA2u7b+WtyZGXHTGg597IJm4EgCbW6W4H4PkWN4
 LJhmivA+SGfOktzXaIbySbav5T4GCvmP/bmuSl73GjGrY5BmlP0VwHc7QmCvzHtbqGu8
 dCCPBAhxvJN7uDkAsIk+hRK24JnYE2wbowHD/N7zUbQCKlYfPp7rmYbyaSGitbUElclU qw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gjadxg10h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Jun 2022 16:44:01 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 257GghsM012497;
        Tue, 7 Jun 2022 16:44:01 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gjadxg0yv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Jun 2022 16:44:01 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 257GMsV9030399;
        Tue, 7 Jun 2022 16:43:58 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3gfxnhv2gj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Jun 2022 16:43:58 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 257Ght2i15204772
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 7 Jun 2022 16:43:56 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E091311C04C;
        Tue,  7 Jun 2022 16:43:55 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A0E0D11C04A;
        Tue,  7 Jun 2022 16:43:55 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.40])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  7 Jun 2022 16:43:55 +0000 (GMT)
Date:   Tue, 7 Jun 2022 18:43:54 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, scgl@linux.ibm.com, pmorel@linux.ibm.com,
        thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v1 2/2] lib: s390x: better smp interrupt
 checks
Message-ID: <20220607184354.06582d6a@p-imbrenda>
In-Reply-To: <20220607164857.53dac498@li-ca45c2cc-336f-11b2-a85c-c6e71de567f1>
References: <20220603154037.103733-1-imbrenda@linux.ibm.com>
        <20220603154037.103733-3-imbrenda@linux.ibm.com>
        <20220607162309.25e97913@li-ca45c2cc-336f-11b2-a85c-c6e71de567f1>
        <20220607164113.5d51f37d@p-imbrenda>
        <20220607164857.53dac498@li-ca45c2cc-336f-11b2-a85c-c6e71de567f1>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: wVPM5eoko8uH4OaZBfPrhf1LcuBNcTpN
X-Proofpoint-ORIG-GUID: -_YQ_SXaPJau3IJU02Ky1uBn0bXLpDD0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-07_07,2022-06-07_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 spamscore=0 clxscore=1015 bulkscore=0 phishscore=0
 adultscore=0 priorityscore=1501 impostorscore=0 mlxscore=0 mlxlogscore=877
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206070067
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 7 Jun 2022 16:48:57 +0200
Nico Boehr <nrb@linux.ibm.com> wrote:

> On Tue, 7 Jun 2022 16:41:13 +0200
> Claudio Imbrenda <imbrenda@linux.ibm.com> wrote:
> 
> > yes I have considered that (maybe I should add this in the patch
> > description)  
> 
> Yes, and not just that; maybe rename expect_ext_int to expect_ext_int_on_this_cpu, same for register_io_int_func.

fair enough
