Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 193FD4B5595
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 17:07:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240943AbiBNQHF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 11:07:05 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232356AbiBNQHB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 11:07:01 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC430C73
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 08:06:53 -0800 (PST)
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21EEhPwt006032
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 16:06:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=drvmT2dmSTf1Slc1F/OTQolMPK1WXrOSg/jBVh3CTLk=;
 b=f4ZdtaPWANCp4hzQejeNdHWtVdwH1EtMhMV39rEF5HujAclFKAjsMvx3YphKq+xcaX1l
 KEBbwLz9W92Owq1aBRY+dyWwoOs0BM5e6VLI37g8+PQmlNWpTSUFqQSCqrdyV7Sn0t4e
 eQugMTftRPSYI2fYKg0TqrY2SW+gC0xYVlvXkGnctY9PwbTQtmymHlNARZEBwYFHhEdp
 zV4QIGbQDTX1TTsPsnGJSKB7UaEAi5MdipK8LhXJREZwj7LXJ4VE6ZkcLCHNAiDieBKC
 cPhL0oz9x+me69yC3F3L+amyOl+b27Vdj1BdShcNe+h9fV9a6bB1r9UqOyif7J52HzlN uw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e79fvwfah-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 16:06:53 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21EEbSc8020899
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 16:06:52 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e79fvwf9t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Feb 2022 16:06:52 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21EFvvln024645;
        Mon, 14 Feb 2022 16:06:50 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma05fra.de.ibm.com with ESMTP id 3e64h9e64w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Feb 2022 16:06:50 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21EG6lRL40305098
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Feb 2022 16:06:47 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 279D55204F;
        Mon, 14 Feb 2022 16:06:47 +0000 (GMT)
Received: from li-ca45c2cc-336f-11b2-a85c-c6e71de567f1.ibm.com (unknown [9.171.29.228])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id C2F8452054;
        Mon, 14 Feb 2022 16:06:46 +0000 (GMT)
Message-ID: <794b194f6f9979f25b922ad60f12fb6afa690848.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v2 5/6] s390x: skrf: use CPU indexes
 instead of addresses
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, thuth@redhat.com, david@redhat.com,
        scgl@linux.ibm.com, seiden@linux.ibm.com
Date:   Mon, 14 Feb 2022 17:06:46 +0100
In-Reply-To: <20220204130855.39520-6-imbrenda@linux.ibm.com>
References: <20220204130855.39520-1-imbrenda@linux.ibm.com>
         <20220204130855.39520-6-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.3 (3.42.3-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: OG9sGX16svXjDzyf9jm_okwAiB6IrXEE
X-Proofpoint-ORIG-GUID: ReHAXGPTp_Kh9RYDZEZ-6hr9zvdf6pb-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-14_06,2022-02-14_03,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 bulkscore=0
 malwarescore=0 suspectscore=0 spamscore=0 mlxscore=0 lowpriorityscore=0
 impostorscore=0 priorityscore=1501 phishscore=0 mlxlogscore=970
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202140094
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-02-04 at 14:08 +0100, Claudio Imbrenda wrote:
> Adapt the test to the new semantics of the smp_* functions, and use
> CPU
> indexes instead of addresses.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
